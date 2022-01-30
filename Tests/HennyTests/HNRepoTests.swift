import XCTest

@testable import Henny

final class HNRepoTests: XCTestCase {

    // MARK: Item

    func testItem() async throws {
        let item = try await HNRepo.item(id: 1)

        print(item)
    }

    func testItems() async throws {
        let items = try await HNRepo.items(ids: [1, 2])

        print(items)
    }

    // MARK: Story

    func testStoryIdentifiers() async throws {
        let storyIdentifiers = try await HNRepo.storyIdentifiers(type: .top)

        print(storyIdentifiers)
    }

    func testStoryItems() async throws {
        let storyItems = try await HNRepo.storyItems(type: .top)

        print(storyItems)
    }

    func testStoryItemsLimit() async throws {
        let storyItems = try await HNRepo.storyItems(type: .ask, limit: 25)

        print(storyItems)
    }

    func testStoryItemsExceedLimit() async throws {
        let storyItems = try await HNRepo.storyItems(type: .ask, limit: 2000)

        print(storyItems)

        // Not yet supported.
        //XCTAssertThrowsError(try await HNRepo.storyItems(type: .ask, limit: 2000))
    }

    // MARK: User

    func testUser() async throws {
        let user = try await HNRepo.user(id: "dang")

        print(user)
    }

    // MARK: Auth

//    func testUpvoteItem() async throws {
//        try await HNRepo.upvoteItem(id: 1)
//    }

    // MARK: Misc

    func testMaxItem() async throws {
        let maxItem = try await HNRepo.maxItem()

        print(maxItem)
    }

    func testUpdates() async throws {
        let updates = try await HNRepo.updates()

        print(updates)
    }
}
