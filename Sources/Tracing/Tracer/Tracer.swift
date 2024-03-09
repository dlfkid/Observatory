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
    
    func createSpan(name: String, kind: SpanKind, context: Context<SpanContext>, attributes: [ObservatoryKeyValue]?, startTimeUnixNano: TimeInterval?, linkes:[Link]?) -> ReadableSpan
}

public class Tracer: Tracerable {
    
    private weak var provider: (AnyObject & TracerProvidable)?
    
    private lazy var spanOperateQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.leondeng.Observatory.spanOperateQueue", qos: .utility)
        return queue
    }()
    
    private var lastSpan: Span?
    
    public func recentSpan() -> ReadableSpan? {
        var recentSpan: ReadableSpan? = nil
        spanOperateQueue.sync {
            if let span = lastSpan {
                recentSpan = ReadableSpan(internalSpan: span)
            }
        }
        return recentSpan
    }
    
    public func createSpan(name: String, kind: SpanKind, context: Context<SpanContext>, attributes: [ObservatoryKeyValue]?, startTimeUnixNano: TimeInterval?, linkes: [Link]?) -> ReadableSpan {
        if let spanContext = context.acquireValue(key: "spanContext") {
            currentContext = spanContext
            let span = Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope:scope, provider: provider, queue: spanOperateQueue)
            return ReadableSpan(internalSpan: span)
        }
        if let currentContext = currentContext {
            let spanId = generateSpanID()
            let spanContext = SpanContext(trace: currentContext.trace, span: spanId, sampledFlag: currentContext.sampledFlag, isRemote: currentContext.isRemote)
            let span = Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope:scope, provider: provider, queue: spanOperateQueue)
            return ReadableSpan(internalSpan: span)
        }
        let traceId = generateTraceID()
        let spanId = generateSpanID()
        let spanContext = SpanContext(trace: traceId, span: spanId, sampledFlag: 0, isRemote: false)
        let span = Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope: scope, provider: provider, queue: spanOperateQueue)
        span.startTimeUnixNano = startTimeUnixNano ?? 0
        provider?.onSpanStarted(span: span)
        return ReadableSpan(internalSpan: span)
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
