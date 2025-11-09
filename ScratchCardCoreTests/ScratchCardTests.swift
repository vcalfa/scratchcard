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
        let scratchedCard = try ScratchCard(scratchCard: card)
        XCTAssertEqual(scratchedCard.state, .scratched, "Transform card to scratched state")
    }
    
    func test_activate_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        let scratchedCard = try ScratchCard(scratchCard: card)
        let activateCard = try ScratchCard(activateCard: scratchedCard)
        XCTAssertEqual(activateCard.state, .activated, "Transform card to activated state")
    }
    
    func test_scratch_code_is_nil_for_unscratch_card() throws {
        let card = ScratchCard(code: "123456")
        XCTAssertNil(card.activationCode?.code, "Scratch card must not revile it's code while it's in unscratched state")
    }
    
    func test_scratch_code_is_revealed_scratch_state() throws {
        let card = ScratchCard(code: "123456")
        let scratchedCard = try ScratchCard(scratchCard: card)
        XCTAssertEqual(scratchedCard.activationCode?.code, "123456", "Scratch card must revile it's code while it's in scratched state")
    }
    
    func test_scratch_code_didnt_change() throws {
        let card = ScratchCard(code: "123456")
        let scratchedCard = try ScratchCard(scratchCard: card)
        let activatedCard = try ScratchCard(activateCard: scratchedCard)
        XCTAssertEqual(activatedCard.activationCode?.code, "123456", "Scratch card must revile it's code while it's in activated state")
    }
    
    func test_id_dont_change() throws {
        let card = ScratchCard(code: "123456")
        let id = card.id
        let scratchedCard = try ScratchCard(scratchCard: card)
        let id2 = scratchedCard.id
        XCTAssertEqual(id, id2, "Card's id must be the same while transforming between states")
        let activatedCard = try ScratchCard(activateCard: scratchedCard)
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
        
        var scratchedCard: ScratchCard<UUID>?
        do {
            scratchedCard = try ScratchCard(activateCard: card)
            XCTAssert(false, "This should not happen, activation of unscratched card must throw an error")
        } catch {
            XCTAssert(scratchedCard == nil, "Activation of unscratched card must throw an error")
        }
    }
    
    func test_scratch_activated_card() throws {
        let card = ScratchCard(generator: UUIDCodeGenerator())
        let scratchedCard = try ScratchCard(scratchCard: card)
        let activateCard = try ScratchCard(activateCard: scratchedCard)
        
        var resultCard: ScratchCard<UUID>?
        do {
            resultCard = try ScratchCard(scratchCard: activateCard)
            XCTAssert(false, "This should not happen, scratching an activated card must throw an error")
        } catch {
            XCTAssert(resultCard == nil, "Scratching an activated card must throw an error")
        }
    }
}
