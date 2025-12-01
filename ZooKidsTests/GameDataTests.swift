//
//  GameDataTests.swift
//  ZooKidsTests
//
//  Created by ZooKids Team on 27/11/25.
//

import XCTest
@testable import ZooKids

final class GameDataTests: XCTestCase {
    
    var gameData: GameData!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gameData = GameData()
        // Reset state for testing
        gameData.coins = 100
        gameData.xp = 0
        gameData.unlockedItemIds = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gameData = nil
    }
    
    func testInitialState() {
        XCTAssertEqual(gameData.coins, 100)
        XCTAssertEqual(gameData.xp, 0)
        XCTAssertEqual(gameData.level, 1)
    }
    
    func testAddXP() {
        gameData.addXP(50)
        XCTAssertEqual(gameData.xp, 50)
        XCTAssertEqual(gameData.level, 1)
        
        gameData.addXP(60) // Total 110
        XCTAssertEqual(gameData.xp, 110)
        XCTAssertEqual(gameData.level, 2)
    }
    
    func testBuyItem_Success() {
        let item = ShopItem(id: "test_hat", name: "Test Hat", description: "A hat", iconName: "hat", price: 50, category: "Ropa")
        
        gameData.buyItem(item)
        
        XCTAssertEqual(gameData.coins, 50) // 100 - 50
        XCTAssertTrue(gameData.unlockedItemIds.contains("test_hat"))
    }
    
    func testBuyItem_InsufficientFunds() {
        let item = ShopItem(id: "expensive_item", name: "Expensive", description: "Too much", iconName: "star", price: 200, category: "Ropa")
        
        gameData.buyItem(item)
        
        XCTAssertEqual(gameData.coins, 100) // No change
        XCTAssertFalse(gameData.unlockedItemIds.contains("expensive_item"))
    }
    
    func testBuyItem_AlreadyOwned() {
        let item = ShopItem(id: "test_hat", name: "Test Hat", description: "A hat", iconName: "hat", price: 50, category: "Ropa")
        
        gameData.buyItem(item) // First buy
        gameData.coins = 100 // Reset coins
        gameData.buyItem(item) // Second buy attempt
        
        XCTAssertEqual(gameData.coins, 100) // Should not charge again
    }
}
