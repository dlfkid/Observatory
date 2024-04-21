//
//  ContextGeneratable.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol TelemetryID {
    var raw: [UInt8] {get}
}

extension TelemetryID {
    public var bytes: Data {
        return Data(raw)
    }
    
    public var string: String {
        return bytes.base64EncodedString()
    }
}

public struct TraceID: TelemetryID, Hashable {
    public var raw: [UInt8]
}

public struct SpanID: TelemetryID, Hashable {
    public var raw: [UInt8]
}

public protocol SpanContextGenerateable {
}

extension SpanContextGenerateable {
    
    public func generateTraceID() -> TraceID {
        return TraceID(raw: generateSecureRandomBytes(length: 16))
    }
    
    public func generateSpanID() -> SpanID {
        return SpanID(raw: generateSecureRandomBytes(length: 8))
    }
    
    private func generateSecureRandomBytes(length: Int) -> [UInt8] {
        var randomBytes = [UInt8](repeating: 0, count: length)
        
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
        
        if status == errSecSuccess {
            return randomBytes
        } else {
            var randomBytes = [UInt8](repeating: 0, count: length)
                
            for i in 0..<length {
                let randomValue = arc4random_uniform(256)
                randomBytes[i] = UInt8(randomValue)
            }
            
            return randomBytes
        }
    }
}

