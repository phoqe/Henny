import XCTest

@testable import Henny

final class HNRepoTests: XCTestCase {
    
    // MARK: Item

    let validItemIds = [1, 1232, 272, 484, 457]
    let invalidItemIds = [-1231231231, 12312321123312, -12122112, 1212312312, 213123123123, 21312123123321]
    
    func testItemWithValidIds() async throws {
        for id in validItemIds {
            let _ = try await HNRepo.item(id: id)
        }
    }
    
    // should fail
    func testItemWithInvalidIds() async throws {
        for id in invalidItemIds {
            let _ = try await HNRepo.item(id: id)
        }
    }
    
    // MARK: Items
    
    func testItemsWithValidIds() async throws {
        let _ = try await HNRepo.items(ids: validItemIds)
    }
    
    // should fail
    func testItemsWithInvalidIds() async throws {
        let _ = try await HNRepo.items(ids: invalidItemIds)
    }
    
    func testItemsWithNoIds() async throws {
        let _ = try await HNRepo.items(ids: [])
    }

    // MARK: Story
    
    let storyTypes = HNStoryType.allCases

    func testStoryIdsWithAllStoryTypes() async throws {
        for storyType in storyTypes {
            let _ = try await HNRepo.storyIds(type: storyType)
        }
    }

    func testStoryItemsWithAllStoryTypes() async throws {
        for storyType in storyTypes {
            let _ = try await HNRepo.storyItems(type: storyType)
        }
    }
    
    let validLimits = [10, 25, 50, 100, 150, 199]

    func testStoryItemsLimitWithAllStoryTypesAndValidLimits() async throws {
        for storyType in storyTypes {
            for limit in validLimits {
                let _ = try await HNRepo.storyItems(type: storyType, limit: limit)
            }
        }
    }
    
    let invalidLimits = [-1, -12002912, 200, 400, 300, 500, 900, 1000]
    
    // should fail
    func testStoryItemsLimitWithAllStoryTypesAndInvalidLimits() async throws {
        for storyType in storyTypes {
            for limit in invalidLimits {
                let _ = try await HNRepo.storyItems(type: storyType, limit: limit)
            }
        }
    }
    
    let validOffsets = [10, 25, 50, 12, 23, 48]
    
    func testStoryItemsLimitWithAllStoryTypesAndValidLimitsAndValidOffsets() async throws {
        for storyType in storyTypes {
            for limit in validLimits {
                for offset in validOffsets {
                    let _ = try await HNRepo.storyItems(type: storyType, limit: limit, offset: offset)
                }
            }
        }
    }

    // MARK: User
    
    let validUsers = ["dang", "Phoqe", "0xPersona", "pseudolus", "mikece"]

    func testUserValidUsers() async throws {
        for user in validUsers {
            let _ = try await HNRepo.user(id: user)
        }
    }
    
    let invalidUsers = ["u912d9j812j9d21", "9k21d9kd", "102i09d1kd921k90d", "91912d8j9d12j891d2j89", "89jd12d81"]
    
    // should fail
    func testUserInvalidUsers() async throws {
        for user in invalidUsers {
            let _ = try await HNRepo.user(id: user)
        }
    }

    // MARK: Misc

    func testMaxItem() async throws {
        let _ = try await HNRepo.maxItem()
    }

    func testUpdates() async throws {
        let _ = try await HNRepo.updates()
    }
}
