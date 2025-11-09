//
//  APIService.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public protocol APIServiceProtocol {
    func activateScratchCard(code: String) async throws -> Bool
}

enum APIError: Error {
    case invalidStatusCode
}

public final class APIService: APIServiceProtocol {
    
    let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func requestURL(for endpoint: Endpoint) async throws -> (Data, URLResponse) {
        let url = baseURL.appending(component: endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await URLSession.shared.data(for: request)
    }
    
    public func activateScratchCard(code: String) async throws -> Bool {
        let (data, response) = try await requestURL(for: .activateScratchCard(code: code))
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidStatusCode
        }
        
        let decodedResponse = try JSONDecoder().decode(ActivationResponse.self, from: data)
        return decodedResponse.ios > 6.1
    }
}
