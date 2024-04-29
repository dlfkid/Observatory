//
//  File.swift
//  
//
//  Created by LeonDeng on 2024/2/24.
//

import Foundation

public struct InstrumentationScope: Hashable, Equatable {
  // An empty instrumentation scope name means the name is unknown.
    let name: String?
    let version: String?
    let schemaURL: String?
}

extension InstrumentationScope: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        version = try container.decode(String.self, forKey: .version)
        schemaURL = try container.decodeIfPresent(String.self, forKey: .schemaURL)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(version, forKey: .version)
        try container.encode(schemaURL, forKey: .schemaURL)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case version
        case schemaURL
    }
}

public protocol Scopable {
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
}

extension Scopable {
    public var scope: InstrumentationScope {
        return InstrumentationScope(name: name, version: version, schemaURL: schemaURL)
    }
}
