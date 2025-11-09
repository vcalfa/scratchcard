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
        self.ios = try container.decode(Double.self, forKey: .ios)
    }
}
