//
//  ActivationResponse.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import Foundation

struct ActivationResponse: Decodable {
    let ios: Double
    
    enum CodingKeys: CodingKey {
        case ios
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let number = try? container.decode(Double.self, forKey: .ios) {
            ios = number
        }
        else if let string = try? container.decode(String.self, forKey: .ios) {
            guard let number = Double(string) else {
                throw DecodingError.dataCorruptedError(forKey: .ios, in: container, debugDescription: "Invalid double string: \(string)")
            }
            ios = number
        } else {
            throw DecodingError.dataCorruptedError(forKey: .ios, in: container, debugDescription: "iOS could not be decoded as Double or String"
            )
        }
    }
}
