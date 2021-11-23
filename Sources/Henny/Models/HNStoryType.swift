import Foundation

/// The different types of stories there are on Hacker News.
/// You can use this enum to query the different endpoints.
enum HNStoryType: String, Codable {
    case top
    case new
    case best
    case ask
    case show
    case job
}
