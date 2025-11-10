//
//  ScratchCardServiceTests.swift
//  ScratchCardCoreTests
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import XCTest
@testable import ScratchCardCore

final class ScratchCardTests: XCTestCase {

    func test_unscratch_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        XCTAssertEqual(card.state, .unscratched, "Initial state of card must be unscratch")
    }
    
    func test_scratch_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        let scratchedCard = card.scratch()
        XCTAssertEqual(scratchedCard.state, .scratched, "Transform card to scratched state")
    }
    
    func test_activate_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        let scratchedCard = card.scratch()
        let activateCard = scratchedCard.activate()
        XCTAssertEqual(activateCard.state, .activated, "Transform card to activated state")
    }
    
    func test_scratch_code_is_nil_for_unscratch_card() throws {
        let card = ScratchCard(code: "123456")
        XCTAssertNil(card.activationCode?.code, "Scratch card must not revile it's code while it's in unscratched state")
    }
    
    func test_scratch_code_is_revealed_scratch_state() throws {
        let card = ScratchCard(code: "123456")
        let scratchedCard = card.scratch()
        XCTAssertEqual(scratchedCard.activationCode?.code, "123456", "Scratch card must revile it's code while it's in scratched state")
    }
    
    func test_scratch_code_didnt_change() throws {
        let card = ScratchCard(code: "123456")
        let scratchedCard = card.scratch()
        let activatedCard = scratchedCard.scratch()
        XCTAssertEqual(activatedCard.activationCode?.code, "123456", "Scratch card must revile it's code while it's in activated state")
    }
    
    func test_id_dont_change() throws {
        let card = ScratchCard(code: "123456")
        let id = card.id
        let scratchedCard = card.scratch()
        let id2 = scratchedCard.id
        XCTAssertEqual(id, id2, "Card's id must be the same while transforming between states")
        let activatedCard = scratchedCard.activate()
        let id3 = activatedCard.id
        XCTAssertEqual(id2, id3, "Card's id must be the same while transforming between states")
    }
    
    func test_id_is_different() throws {
        let card1 = ScratchCard(code: "123456")
        let card2 = ScratchCard(code: "123456")
        XCTAssertNotEqual(card1.id, card2.id, "Card's id must be different for cards with same codes it means id's are independent from code")
    }
    
    func test_activate_unscratched_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        XCTAssertEqual(card.state, .unscratched, "Should return an unscratched card by default")
        
        let activatedCard = card.activate()
        
        XCTAssertEqual(activatedCard.state, .unscratched , "Activation of unscratched card must not change it's state")
    }
    
    func test_scratch_activated_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        let scratchedCard = card.scratch()
        let activateCard = scratchedCard.activate()
        let resultCard = activateCard.scratch()
        XCTAssertEqual(resultCard.state, .activated , "Scratching an activated don't change it state")
    }
}
