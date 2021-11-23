import Foundation

/// A container for a Hacker News update.
/// Through here you can view the items and profiles that were updated recently.
struct HNUpdate: Codable {
    /// The items on Hacker News that were changed recently.
    let items: [Int]

    /// The profiles on Hacker News that were changed recently.
    let profiles: [String]
}
