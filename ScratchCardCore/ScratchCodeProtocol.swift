//
//  ScratchCodeProtocol.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public protocol ScratchCodeProtocol {
    var code: String { get }
}

extension String: ScratchCodeProtocol {
    public var code: String { self }
}

extension UUID: ScratchCodeProtocol {
    public var code: String { self.uuidString }
}
