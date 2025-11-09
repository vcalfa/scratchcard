//
//  CodeGeneratorProtocol.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public protocol CodeGeneratorProtocol {
    associatedtype T: ScratchCodeProtocol
    func generateCode() -> T
}

final public class StringCodeGenerator: CodeGeneratorProtocol {
    public init() {}
    
    public func generateCode() -> String {
        Self.randomString(of: 6)
    }
    
    static func randomString(of length: Int) -> String {
        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
}

final public class UUIDCodeGenerator: CodeGeneratorProtocol {
    
    public init() {}
    
    public func generateCode() -> UUID {
        UUID()
    }
}
