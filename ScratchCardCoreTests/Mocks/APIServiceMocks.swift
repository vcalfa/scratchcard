//
//  APIServiceAlwaisFail.swift
//  ScratchCardCoreTests
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import Foundation
@testable import ScratchCardCore

enum APIError: Error {
    case networkError
}

final class APIServiceFail: APIServiceProtocol {
    func activateScratchCard(code: String) async throws -> Bool {
        false
    }
}

final class APIServiceSucceed: APIServiceProtocol {
    func activateScratchCard(code: String) async throws -> Bool {
        true
    }
}

final class APIServiceThrow: APIServiceProtocol {
    func activateScratchCard(code: String) async throws -> Bool {
        throw APIError.networkError
    }
}
