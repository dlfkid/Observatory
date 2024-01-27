//
//  Tracer.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
import ObservatoryCommon

public protocol Tracerable: SpanContextGenerateable {
    
    var currentContext: SpanContext? {get}
    
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
    
    func createSpan(name: String, kind: SpanKind, context: Context<SpanContext>, attributes: [ObservatoryKeyValue]?, startTimeStamp: TimeInterval, linkes:[Link]?) -> Span
}

public class Tracer: Tracerable {
    public func createSpan(name: String, kind: SpanKind, context: Context<SpanContext>, attributes: [ObservatoryKeyValue]?, startTimeStamp: TimeInterval, linkes: [Link]?) -> Span {
        if let spanContext = context.acquireValue(key: "spanContext") {
            currentContext = spanContext
            return Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes)
        }
        if let currentContext = currentContext {
            let spanId = generateSpanID()
            let spanContext = SpanContext(trace: currentContext.trace, span: spanId, sampledFlag: currentContext.sampledFlag, isRemote: currentContext.isRemote)
            return Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes)
        }
        let traceId = generateTraceID()
        let spanId = generateSpanID()
        let spanContext = SpanContext(trace: traceId, span: spanId, sampledFlag: 0, isRemote: false)
        return Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes)
    }
    
    public var currentContext: SpanContext?
    
    public let version: String
    
    public let name: String
    
    public let schemaURL: String?
    
    public let limit: SpanLimit
    
    init(version: String, name: String, schemaURL: String? = nil, limit: SpanLimit) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
        self.limit = limit
    }
}
