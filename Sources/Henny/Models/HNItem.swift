import Foundation
import Ogge

/// On Hacker News, items are everything.
/// Stories, comments, polls, etc.
struct HNItem: Codable {

    // MARK: API

    /// The item's unique ID.
    let id: Int

    /// Whether the item is deleted.
    /// It can be deleted by administrators and anti-abuse software.
    let deleted: Bool?

    /// The type of item.
    /// See `HNItemType` for more info.
    let type: HNItemType?

    /// The username of the author.
    let by: String?

    /// The date the item was created.
    let time: Date?

    /// The text content of a story.
    /// It's in HTML.
    let text: String?

    /// Whether the item is dead.
    /// Items can die and be revived by users with a specific karma threshold.
    let dead: Bool?

    /// The parent of a comment since comments can nest.
    let parent: Int?

    /// A poll option's associated poll.
    let poll: Int?

    /// The IDs of an item's comments in a ranked display order.
    let kids: [Int]?

    /// The URL of a story. This can be an article or whatever website.
    let url: URL?

    /// The score of the item. Users on Hacker News can upvote stories they find intellectual.
    let score: Int?

    /// The title of a story, poll, or job. It's in HTML.
    let title: String?

    /// A list of related poll options in a display order.
    let parts: [Int]?

    /// The total comment count for stories and polls.
    let descendants: Int?

    // MARK: Convenience

    /// A convenience mirror of `by`.
    var author: String? {
        by
    }

    /// Mirror of `time` for convenience.
    var created: Date? {
        time
    }

    /// A mirror of `text`.
    var body: String? {
        text
    }

    /// A mirror of `kids`. Simply, the IDs of the item's comments in a ranked display order.
    /// See `kids` for more info.
    var comments: [Int]? {
        kids
    }

    /// A mirror of `score` to adhere to more naming schemes.
    var karma: Int? {
        score
    }

    /// Like `karma`, a mirror of `score`.
    /// See `score` for more info.
    var upvotes: Int? {
        score
    }

    /// A mirror of `descendants`.
    /// See `descendants` for more info.
    var commentCount: Int? {
        descendants
    }

    // MARK: Custom

    /// The URL to the item on Hacker News.
    var hnURL: URL {
        HNRepo.hnURL.appendingPathComponent("item?id=\(id)")
    }

    /// The Open Graph metadata associated with the URL of the story.
    /// This property uses Ogge internally which is a library for fetching Open Graph properties from URLs.
    var meta: OGObject? {
        get async throws {
            guard let url = url else {
                return nil
            }

            return try await OGRepo.object(from: url)
        }
    }
}
