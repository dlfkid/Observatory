//
//  Tracer.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public protocol Tracerable {
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
}

public struct Tracer: Tracerable {
    public let version: String
    
    public let name: String
    
    public let schemaURL: String?
    
    init(version: String, name: String, schemaURL: String? = nil) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
    }
}
