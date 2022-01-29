import Foundation
import Ogge

/// On Hacker News, items are everything.
/// Stories, comments, polls, etc.
public struct HNItem: Codable, Identifiable {

    // MARK: API

    /// The item's unique ID.
    public let id: Int

    /// Whether the item is deleted.
    /// It can be deleted by administrators and anti-abuse software.
    public let deleted: Bool?

    /// The type of item.
    /// See `HNItemType` for more info.
    public let type: HNItemType?

    /// The username of the author.
    public let by: String?

    /// The date the item was created.
    public let time: Date?

    /// The text content of a story.
    /// It's in HTML.
    public let text: String?

    /// Whether the item is dead.
    /// Items can die and be revived by users with a specific karma threshold.
    public let dead: Bool?

    /// The parent of a comment since comments can nest.
    public let parent: Int?

    /// A poll option's associated poll.
    public let poll: Int?

    /// The IDs of an item's comments in a ranked display order.
    public let kids: [Int]?

    /// The URL of a story. This can be an article or whatever website.
    public let url: URL?

    /// The score of the item. Users on Hacker News can upvote stories they find intellectual.
    public let score: Int?

    /// The title of a story, poll, or job. It's in HTML.
    public let title: String?

    /// A list of related poll options in a display order.
    public let parts: [Int]?

    /// The total comment count for stories and polls.
    public let descendants: Int?

    // MARK: Custom

    /// The URL to the item on Hacker News.
    public var hnURL: URL {
        URL(string: "\(HNRepo.hnURL.absoluteString)/item?id=\(id)")!
    }

    /// The Open Graph metadata associated with the URL of the story.
    /// This property uses Ogge internally which is a library for fetching Open Graph properties from URLs.
    public var meta: OGObject? {
        get async throws {
            guard let url = url else {
                return nil
            }

            return try await OGRepo.object(from: url)
        }
    }

    public init(
        id: Int,
        deleted: Bool?,
        type: HNItemType?,
        by: String?,
        time: Date?,
        text: String?,
        dead: Bool?,
        parent: Int?,
        poll: Int?,
        kids: [Int]?,
        url: URL?,
        score: Int?,
        title: String?,
        parts: [Int]?,
        descendants: Int?
    ) {
        self.id = id
        self.deleted = deleted
        self.type = type
        self.by = by
        self.time = time
        self.text = text
        self.dead = dead
        self.parent = parent
        self.poll = poll
        self.kids = kids
        self.url = url
        self.score = score
        self.title = title
        self.parts = parts
        self.descendants = descendants
    }
}
