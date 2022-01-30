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

    func testStoryIds() async throws {
        let storyIds = try await HNRepo.storyIds(type: .top)

        print(storyIds)
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
    }

    // MARK: User

    func testUser() async throws {
        let user = try await HNRepo.user(id: "dang")

        print(user)
    }

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
