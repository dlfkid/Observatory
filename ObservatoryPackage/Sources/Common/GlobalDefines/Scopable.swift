//
//  File.swift
//  
//
//  Created by LeonDeng on 2024/2/24.
//

import Foundation

public struct InstrumentationScope: Hashable, Equatable {
  // An empty instrumentation scope name means the name is unknown.
    let name: String
    let version: String
    let schemaURL: String?
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
