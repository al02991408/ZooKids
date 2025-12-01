//
//  ViewModelTests.swift
//  ZooKidsTests
//
//  Created by ZooKids Team on 27/11/25.
//

import XCTest
@testable import ZooKids

final class ViewModelTests: XCTestCase {
    
    func testLetterRaceLogic() {
        let vm = LetterRaceViewModel()
        
        // Initial state
        XCTAssertEqual(vm.currentLetter, "A")
        XCTAssertFalse(vm.isLetterCompleted)
        
        // Simulate correct tracing (simplified for unit test as we can't easily mock geometry)
        // We are testing the state transitions mostly
        
        vm.loadNewLetter()
        XCTAssertEqual(vm.feedbackMessage, "¡Traza la letra!")
    }
    
    func testWordJungleLogic() {
        let vm = WordJungleViewModel()
        
        // Ensure data is loaded
        XCTAssertFalse(vm.targetLetter.isEmpty)
        XCTAssertFalse(vm.options.isEmpty)
        XCTAssertTrue(vm.options.contains(vm.targetLetter))
        
        // Test correct answer
        vm.checkAnswer(selectedLetter: vm.targetLetter)
        XCTAssertTrue(vm.isCorrect == true)
        XCTAssertTrue(vm.feedbackMessage.contains("Excelente"))
        
        // Reset
        vm.loadNewRound()
        vm.isAnswered = false
        
        // Test incorrect answer (find a wrong letter)
        if let wrongLetter = vm.options.first(where: { $0 != vm.targetLetter }) {
            vm.checkAnswer(selectedLetter: wrongLetter)
            XCTAssertTrue(vm.isCorrect == false)
            XCTAssertTrue(vm.feedbackMessage.contains("Incorrecto"))
        }
    }
    
    func testMemoramaLogic() {
        let vm = MemoramaViewModel()
        
        XCTAssertEqual(vm.cards.count, 12) // 6 pairs
        XCTAssertEqual(vm.matchesFound, 0)
        
        // Simulate matching
        let firstCard = vm.cards[0]
        // Find its pair
        if let pairIndex = vm.cards.firstIndex(where: { $0.content == firstCard.content && $0.id != firstCard.id }) {
            let pairCard = vm.cards[pairIndex]
            
            vm.choose(card: firstCard)
            XCTAssertTrue(vm.cards[0].isFaceUp)
            
            vm.choose(card: pairCard)
            
            // Should be a match
            XCTAssertTrue(vm.cards[0].isMatched)
            XCTAssertTrue(vm.cards[pairIndex].isMatched)
            XCTAssertEqual(vm.matchesFound, 1)
        }
    }
}
