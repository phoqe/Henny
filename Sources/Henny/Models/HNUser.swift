import Foundation

/// A model for a Hacker News user.
/// Only users that have public activity on the site are available through the API.
public struct HNUser: Codable {

    // MARK: API

    /// The name might be misleading but the ID is actually the user's username.
    /// It's a required property and case-sensitive.
    public let id: String

    /// When the user was created.
    public let created: Date

    /// How many upvotes the user has received on their submissions.
    public let karma: Int

    /// A user-provided biography where they can enter information about themselves.
    public let about: String?

    /// A list of the user's submissions like stories, polls, and comments.
    public let submitted: [Int]?

    // MARK: Custom

    /// The URL to the user on Hacker News.
    public var hnURL: URL {
        URL(string: "\(HNRepo.hnURL.absoluteString)/user?id=\(id)")!
    }
}
