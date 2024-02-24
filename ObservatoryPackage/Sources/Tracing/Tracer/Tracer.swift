//
//  Tracer.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public protocol Tracerable: SpanContextGenerateable, Scopable {
    
    var currentContext: SpanContext? {get}
    
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
    
    func createSpan(name: String, kind: SpanKind, context: Context<SpanContext>, attributes: [ObservatoryKeyValue]?, startTimeUnixNano: TimeInterval?, linkes:[Link]?) -> Span
}

public class Tracer: Tracerable {
    
    private weak var provider: (AnyObject & TracerProvidable)?
    
    public func createSpan(name: String, kind: SpanKind, context: Context<SpanContext>, attributes: [ObservatoryKeyValue]?, startTimeUnixNano: TimeInterval?, linkes: [Link]?) -> Span {
        if let spanContext = context.acquireValue(key: "spanContext") {
            currentContext = spanContext
            return Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope:scope, provider: provider)
        }
        if let currentContext = currentContext {
            let spanId = generateSpanID()
            let spanContext = SpanContext(trace: currentContext.trace, span: spanId, sampledFlag: currentContext.sampledFlag, isRemote: currentContext.isRemote)
            return Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope:scope, provider: provider)
        }
        let traceId = generateTraceID()
        let spanId = generateSpanID()
        let spanContext = SpanContext(trace: traceId, span: spanId, sampledFlag: 0, isRemote: false)
        let span = Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope: scope, provider: provider)
        span.startTimeUnixNano = startTimeUnixNano ?? 0
        provider?.onSpanStarted(span: span)
        return span
    }
    
    public var currentContext: SpanContext?
    
    public let version: String
    
    public let name: String
    
    public let schemaURL: String?
    
    public let limit: SpanLimit
    
    internal init(version: String, name: String, schemaURL: String? = nil, limit: SpanLimit, provider: (AnyObject & TracerProvidable)) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
        self.limit = limit
    }
}
