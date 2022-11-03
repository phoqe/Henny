import Foundation

/// The repository for accessing Hacker News services.
/// The structure follows a "more variables, easier to debug" structure, so variables are assigned a value which is then returned.
public struct HNRepo {
    /// The URL to Hacker News.
    public static let hnURL = URL(string: "https://news.ycombinator.com")!

    /// The URL to the Hacker News API.
    public static let apiURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!

    /// A reusable `JSONDecoder` that is used to decode data from Hacker News.
    /// It uses `.secondsSince1970` instead of in milliseconds when converting dates since that's what Hacker News uses.
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    /// A shared `URLSession` for use with Hacker News.
    /// Should probably make this more customizable in the future.
    /// Right now, no caching. And users can't modify the session.
    public static let session: URLSession = {
        let config = URLSessionConfiguration.default

        config.requestCachePolicy = .returnCacheDataElseLoad

        return URLSession(configuration: config)
    }()

    // MARK: Item

    /// Fetches a Hacker News item identified by its `id`.
    /// Stories, comments, jobs, Ask HNs, and polls are just items.
    /// All items live under `/v0/item/<id>`
    /// See `HNItem` for more details.
    ///
    /// - Parameters:
    ///    - id: The item's unique ID. It's an incremental integer, i.e., the next item is `id + 1`.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: A Hacker News item.
    ///
    public static func item(id: Int) async throws -> HNItem {
        let url = apiURL
            .appendingPathComponent("item/\(id)")
            .appendingPathExtension("json")
        let (data, _) = try await session.data(from: url)
        let item = try decoder.decode(HNItem.self, from: data)

        return item
    }

    /// Just like the `item(id:)` call but with multiple IDs.
    /// I'll paste the description here for you.
    /// Fetches Hacker News items identified by their ID.
    /// Stories, comments, jobs, Ask HNs, and polls are just items.
    /// See `HNItem` for more details.
    ///
    /// - Parameters:
    ///    - ids: An array of Hacker News item IDs. They are unique IDs and also incremental, i.e. next item is `id + 1`.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: An array of Hacker News items.
    ///
    public static func items(ids: [Int]) async throws -> [HNItem] {
        // Don't waste any more time with setting up task groups.
        if ids.isEmpty {
            return [HNItem]()
        }

        return try await withThrowingTaskGroup(of: HNItem.self, body: { taskGroup in
            for id in ids {
                taskGroup.addTask {
                    try await item(id: id)
                }
            }

            var items = [HNItem]()

            items.reserveCapacity(ids.count)

            for try await item in taskGroup {
                items.append(item)
            }

            return items
        })
    }

    // MARK: Story

    /// Fetches the story identifiers for a story type.
    /// Up to 500 `top` and `new` stories are available.
    /// Up to 200 of the latest Ask HN, Show HN, and job stories are available.
    /// This function only returns their IDs and not the items.
    ///
    /// - Parameters:
    ///    - type: The type of stories to fetch. Different story types have different number of IDs available.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: A list of story identifiers for the given story type.
    ///
    public static func storyIds(type: HNStoryType) async throws -> [Int] {
        let url = apiURL
            .appendingPathComponent("\(type.rawValue)stories")
            .appendingPathExtension("json")
        let (data, _) = try await session.data(from: url)
        let storyIds = try decoder.decode([Int].self, from: data)

        return storyIds
    }

    /// Fetches the story items for a story type.
    /// Up to 500 `top` and `new` stories are available.
    /// Up to 200 of the latest Ask HN, Show HN, and job stories are available.
    ///
    /// - Parameters:
    ///    - type: The type of stories to fetch. Different story types have different number of items available.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: A list of story items for the given story type.
    ///
    public static func storyItems(type: HNStoryType) async throws -> [HNItem] {
        let storyIds = try await storyIds(type: type)

        if storyIds.isEmpty {
            return [HNItem]()
        }

        return try await items(ids: storyIds)
    }

    /// Fetches the story items for a story type using a `limit` for when you want a subset of the stories.
    /// If the amount of available stories is less than the `limit`, you'll get the amount of stories in store.
    /// That is, up to 500 `top` and `new` stories are available and up to 200 of the latest Ask HN, Show HN, and job stories.
    ///
    /// - Parameters:
    ///    - type: The type of stories to fetch. Different story types have different number of items available.
    ///    - limit: The number of stories you want to fetch.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: A list of limited story items for the given story type.
    ///
    public static func storyItems(type: HNStoryType, limit: Int) async throws -> [HNItem] {
        let storyIds = try await storyIds(type: type)

        if storyIds.isEmpty {
            return [HNItem]()
        }

        try validateLimit(storyType: type, limit: limit)

        let limitedStoryIds = limitedStoryIds(storyIds: storyIds, limit: limit)

        return try await items(ids: limitedStoryIds)
    }
    
    public static func storyItems(type: HNStoryType, limit: Int, offset: Int) async throws -> [HNItem] {
        let storyIds = try await storyIds(type: type)

        if storyIds.isEmpty {
            return [HNItem]()
        }

        try validateLimit(storyType: type, limit: limit)

        let limitedStoryIds = limitedStoryIds(storyIds: storyIds, offset: offset, limit: limit)

        return try await items(ids: limitedStoryIds)
    }

    // MARK: User

    /// Fetches a Hacker News user identified by its `id`.
    /// Users are identified by their case-sensitive IDs and live under `/v0/user/`.
    /// Only users that have public activity on the site are available.
    /// Check `HNUser` for more details.
    ///
    /// - Parameters:
    ///    - id: The user's unique ID or username. It's case-sensitive and must be supplied.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: A Hacker News user.
    ///
    public static func user(id: String) async throws -> HNUser {
        let url = apiURL
            .appendingPathComponent("user/\(id)")
            .appendingPathExtension("json")
        let (data, _) = try await session.data(from: url)
        let user = try decoder.decode(HNUser.self, from: data)

        return user
    }

    // MARK: Misc

    /// Fetches the most recent item submitted on Hacker News.
    /// In other words, the current largest item.
    /// Walking backward from here, you can travel back in time to discover all items on Hacker News.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: The current largest item on Hacker News.
    ///
    public static func maxItem() async throws -> Int {
        let url = apiURL
            .appendingPathComponent("maxitem")
            .appendingPathExtension("json")
        let (data, _) = try await session.data(from: url)
        let maxItem = try decoder.decode(Int.self, from: data)

        return maxItem
    }

    /// Fetches details on what's happening on Hacker News right now.
    /// That is, which profiles and items are being updated and such.
    /// The updates are limited to items and profiles.
    ///
    /// - Throws: An error if fetching data from the URL fails or if the decoding fails.
    ///
    /// - Returns: A container for profile and item updates.
    ///
    public static func updates() async throws -> HNUpdate {
        let url = apiURL
            .appendingPathComponent("updates")
            .appendingPathExtension("json")
        let (data, _) = try await session.data(from: url)
        let update = try decoder.decode(HNUpdate.self, from: data)

        return update
    }
}

private extension HNRepo {
    /// Checks whether the limit is within bounds for the given story type.
    private static func validateLimit(storyType: HNStoryType, limit: Int) throws {
        if (storyType == .top || storyType == .new) && limit > 500 {
            throw HNRepoError.limitExceededForStoryType(storyType: storyType, maxLimit: 500)
        }

        if (storyType == .ask || storyType == .show || storyType == .job) && limit > 200 {
            throw HNRepoError.limitExceededForStoryType(storyType: storyType, maxLimit: 200)
        }
    }

    /// Gets the story identifiers that is within bounds of the limit and avoiding index out of bounds exceptions.
    private static func limitedStoryIds(storyIds: [Int], limit: Int) -> [Int] {
        if storyIds.count <= limit {
            return storyIds
        }

        return Array(storyIds.prefix(limit))
    }
    
    private static func limitedStoryIds(storyIds: [Int], offset: Int, limit: Int) -> [Int] {
        if storyIds.count <= limit {
            return storyIds
        }

        return Array(storyIds[offset..<offset+limit])
    }
}

/// A general purpose error structure for use within `HNRepo`.
private enum HNRepoError: Error, LocalizedError {
    case limitExceededForStoryType(storyType: HNStoryType, maxLimit: Int)

    var errorDescription: String? {
        switch self {
        case .limitExceededForStoryType(let storyType, let maxLimit):
            return String(
                format: NSLocalizedString("Maximum limit for story type '%@' is %d.", comment: ""),
                storyType.rawValue,
                maxLimit
            )
        }
    }
}
