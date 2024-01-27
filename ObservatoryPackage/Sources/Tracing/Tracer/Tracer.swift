//
//  Tracer.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
import ObservatoryCommon

public protocol Tracerable {
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
    
    func createSpan(name: String, kind: SpanKind, attributes: [ObservatoryKeyValue]?, startTimeStamp: TimeInterval, linkes:[Link]?) -> Span
}

public struct Tracer: Tracerable {
    public func createSpan(name: String, kind: SpanKind, attributes: [ObservatoryKeyValue]?, startTimeStamp: TimeInterval, linkes: [Link]?) -> Span {
        return Span(name: name, kind: kind, attributes: attributes)
    }
    
    public let version: String
    
    public let name: String
    
    public let schemaURL: String?
    
    init(version: String, name: String, schemaURL: String? = nil) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
    }
}
