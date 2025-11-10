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
        
        let card = sut.getScratchCard()
        
        XCTAssertEqual(card.state, .unscratched, "Getting card from service should return unscratch state")
    }
    
    func test_scratch_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        var card = sut.getScratchCard()
        let cardId = card.id
        try await sut.scratch(&card)
        
        XCTAssertEqual(card.state, .scratched, "Scratching card should return scratched state")
        XCTAssertEqual(card.id, cardId, "Id of card should not change")
    }
    
    func test_activate_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        var card = sut.getScratchCard()

        try await sut.scratch(&card)
        
        XCTAssertEqual(card.state, .scratched, "Scratching card should return scratched state")
        
        try await sut.activate(&card)
        
        XCTAssertEqual(card.state, .activated, "Activating card should return activated state")
    }
    
    func test_activate_unscratched_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceSucceed())
        
        var card = sut.getScratchCard()
        
        XCTAssertEqual(card.state, .unscratched, "Should return scratched state")
        
        do {
            try await sut.activate(&card)
            XCTAssertNotEqual(card.state, .activated, "This should throw an error")
            XCTAssert(false, "This should not be reached")
        } catch {
            XCTAssert(error is ScratchCardError, "Throw error should be of type ScratchCardError")
            XCTAssertEqual(error as? ScratchCardError, .invalidState, "Throw error should be .invalidState")
        }
    }
    
    func test_try_activate_card() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceFail())
        var card = sut.getScratchCard()

        try await sut.scratch(&card)
        
        XCTAssertEqual(card.state, .scratched, "Scratching card should return scratched card's state")
        try await sut.activate(&card)
        
        XCTAssertNotEqual(card.state, .activated, "Failing activation should'n return activated state")
        XCTAssertEqual(card.state, .scratched, "Failing activation should return original state")
    }
    
    func test_try_activate_card_service_throw() async throws {
        let sut = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                     apiService: APIServiceThrow())
        
        var card = sut.getScratchCard()

        try await sut.scratch(&card)
        
        XCTAssertEqual(card.state, .scratched, "Scratching card should return scratched card's state")
        
        do {
            try await sut.activate(&card)
            XCTAssertNotEqual(card.state, .activated, "Throwing activation should'n return activated state")
            XCTAssert(false, "This should not be reached, throwing API service should not activate card")
        } catch {
            XCTAssert(true, "Throwing API service should throw an error")
        }
    }
}
