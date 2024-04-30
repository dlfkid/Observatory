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
    
    public var hexString: String {
        return bytes.hexadecimalString
    }
}

extension Data {
    
    var hexadecimalString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    // Initializer that converts a hexadecimal string into Data
    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        var index = hexString.startIndex
        for _ in 0..<length {
            let nextIndex = hexString.index(index, offsetBy: 2)
            if nextIndex > hexString.endIndex {
                return nil
            }
            guard let b = UInt8(hexString[index..<nextIndex], radix: 16) else {
                return nil
            }
            data.append(b)
            index = nextIndex
        }
        self = data
    }
}


public struct TraceID: TelemetryID, Hashable {
    public var raw: [UInt8]
    
    public static func create(hexString: String) -> TraceID? {
        guard let bytes = Data(hexString: hexString) else { return nil }
        return TraceID(raw: Array(bytes))
    }
}

public struct SpanID: TelemetryID, Hashable {
    public var raw: [UInt8]
    
    public static func create(hexString: String) -> SpanID? {
        guard let bytes = Data(hexString: hexString) else { return nil }
        return SpanID(raw: Array(bytes))
    }
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

