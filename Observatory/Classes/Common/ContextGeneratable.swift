//
//  ContextGeneratable.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

protocol TelemetryID {
    var raw: [UInt8] {get}
}

extension TelemetryID {
    var bytes: Data {
        return Data(raw)
    }
    
    var string: String {
        return String(bytes: raw, encoding: .utf8) ?? ""
    }
}

struct TraceID: TelemetryID, Hashable {
    var raw: [UInt8]
}

struct SpanID: TelemetryID, Hashable {
    var raw: [UInt8]
}

protocol ContextGenerateable {
}

extension ContextGenerateable {
    
    func generateTraceID() -> TraceID {
        return TraceID(raw: generateSecureRandomBytes(length: 16))
    }
    
    func generateSpanID() -> SpanID {
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

