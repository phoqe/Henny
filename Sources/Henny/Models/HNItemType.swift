import Foundation

/// Items can take several forms.
/// Here are all the different ones.
enum HNItemType: String, Codable {
    case job
    case story
    case comment
    case poll
    case pollopt
}
