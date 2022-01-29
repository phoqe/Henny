import Foundation

/// The different types of stories there are on Hacker News.
/// You can use this enum to query the different endpoints.
public enum HNStoryType: String, Codable, CaseIterable, Identifiable {
    case top
    case new
    case best
    case ask
    case show
    case job

    public var id: String {
        self.rawValue
    }
}
