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
    
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
    
    func createSpan(name: String, kind: SpanKind, context: SpanContext?, attributes: [ObservatoryKeyValue]?, startTimeUnixNano: TimeInterval?, linkes:[Link]?) -> ReadableSpan?
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
                recentSpan = span.readableSpan()
            }
        }
        return recentSpan
    }
    
    fileprivate func handleSpanCreation(_ spanContext: SpanContext, _ name: String, _ kind: SpanKind, _ attributes: [ObservatoryKeyValue]?, _ provider: (any AnyObject & TracerProvidable), _ startTimeUnixNano: TimeInterval) -> ReadableSpan? {
        let span = Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope:scope, provider: provider, queue: spanOperateQueue)
        span.startTimeUnixNano = startTimeUnixNano
        provider.onSpanStarted(span: span)
        return span.readableSpan()
    }
    
    public func createSpan(name: String, kind: SpanKind, context: SpanContext?, attributes: [ObservatoryKeyValue]?, startTimeUnixNano: TimeInterval?, linkes: [Link]?) -> ReadableSpan? {
        guard let provider = provider else {
            return nil
        }
        let startTimeUnixNano = startTimeUnixNano ?? provider.timeStampProvider.currentTimeStampMillieSeconds()
        // if there is a context parameter, create span with the parameter context
        if let spanContext = context {
            return handleSpanCreation(spanContext, name, kind, attributes, provider, startTimeUnixNano)
        }
        // if current tracer has no context, create a brand new context as the root span of the trace
        let traceId = generateTraceID()
        let spanId = generateSpanID()
        // only originatly created span needs a sampler to decide wether the span should be sampled and recorded
        let sampleResult = provider.shouldSample(traceID: traceId, name: name, parentSpanID: nil, attributes: attributes, links: linkes, traceState: nil)
        guard sampleResult.decision != .drop else {
            return nil
        }
        let spanContext = SpanContext(trace: traceId, span: spanId, sampledFlag: sampleResult.decision.rawValue, isRemote: false, parentSpan: nil, traceState: sampleResult.traceState)
        return handleSpanCreation(spanContext, name, kind, attributes, provider, startTimeUnixNano)
    }
    
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
