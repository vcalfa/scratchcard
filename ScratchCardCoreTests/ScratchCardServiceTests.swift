//
//  ScratchCardServiceTests.swift
//  ScratchCardCoreTests
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import XCTest
@testable import ScratchCardCore

final class ScratchCardServiceTests: XCTestCase {

    func test_get_card_unscratched() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        let card = await sut.getScratchCard()
        
        XCTAssertEqual(card.state, .unscratched, "Getting card from service should return unscratch state")
    }
    
    func test_scratch_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        let card = await sut.getScratchCard()
        let cardId = card.id
        let scratchedCard = try await sut.scratchCard(card)
        
        XCTAssertEqual(scratchedCard.state, .scratched, "Scratching card should return scratched state")
        XCTAssertEqual(scratchedCard.id, cardId, "Id of card should not change")
    }
    
    func test_activate_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        let card = await sut.getScratchCard()

        let scratchedCard = try await sut.scratchCard(card)
        
        XCTAssertEqual(scratchedCard.state, .scratched, "Scratching card should return scratched state")
        
        let activatedCard = try await sut.activateCard(scratchedCard)
        
        XCTAssertEqual(activatedCard.state, .activated, "Activating card should return activated state")
    }
    
    func test_activate_unscratched_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        let card = await sut.getScratchCard()
        
        XCTAssertEqual(card.state, .unscratched, "Should return scratched state")
        
        do {
            let activatedCard = try await sut.activateCard(card)
            XCTAssertNotEqual(activatedCard.state, .activated, "This should throw an error")
            XCTAssert(false, "This should not be reached")
        } catch {
            XCTAssert(error is ScratchCardError, "Throw error should be of type ScratchCardError")
            XCTAssertEqual(error as? ScratchCardError, .invalidState, "Throw error should be .invalidState")
        }
    }
    
    func test_try_activate_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceFail())
        let card = await sut.getScratchCard()

        let scratchedCard = try await sut.scratchCard(card)
        
        XCTAssertEqual(scratchedCard.state, .scratched, "Scratching card should return scratched card's state")
        let activatedCard = try await sut.activateCard(scratchedCard)
        
        XCTAssertNotEqual(activatedCard.state, .activated, "Failing activation should'n return activated state")
        XCTAssertEqual(activatedCard.state, .scratched, "Failing activation should return original state")
    }
    
    func test_try_activate_card_service_throw() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceThrow())
        
        let card = await sut.getScratchCard()

        let scratchedCard = try await sut.scratchCard(card)
        
        XCTAssertEqual(scratchedCard.state, .scratched, "Scratching card should return scratched card's state")
        
        do {
            let activatedCard = try await sut.activateCard(scratchedCard)
            XCTAssertNotEqual(activatedCard.state, .activated, "Throwing activation should'n return activated state")
            XCTAssert(false, "This should not be reached, throwing API service should not activate card")
        } catch {
            XCTAssert(true, "Throwing API service should throw an error")
        }
    }
}
