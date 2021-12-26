import Foundation

/// A model for a Hacker News user.
/// Only users that have public activity on the site are available through the API.
public struct HNUser: Codable {

    // MARK: API

    /// The name might be misleading but the ID is actually the user's username.
    /// It's a required property and case-sensitive.
    let id: String

    /// When the user was created.
    let created: Date

    /// How many upvotes the user has received on their submissions.
    let karma: Int

    /// A user-provided biography where they can enter information about themselves.
    let about: String?

    /// A list of the user's submissions like stories, polls, and comments.
    let submitted: [Int]?

    // MARK: Convenience

    /// The username property is a convenience mirror of the `id` property.
    /// Usernames are required properties and case-sensitive.
    var username: String {
        id
    }

    /// Mirror of `karma`.
    var score: Int {
        karma
    }

    /// Mirror of `karma`.
    var upvotes: Int {
        karma
    }

    /// A convenience property for `submitted`.
    /// For more information, check that property out.
    var submissions: [Int]? {
        submitted
    }

    // MARK: Custom

    /// The URL to the user on Hacker News.
    var hnURL: URL {
        HNRepo.hnURL.appendingPathComponent("user?id=\(id)")
    }
}
