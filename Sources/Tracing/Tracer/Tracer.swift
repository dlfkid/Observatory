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
    
    func internalCreateSpan(name: String, kind: SpanKind, context: SpanContext?, attributes: [ObservatoryKeyValue]?, startTimeUnix: TimeRepresentable?, linkes:[Link]?, traceState: TraceState?) -> ReadableSpan?
}

extension Tracerable {
    public func createSpan(name: String, kind: SpanKind, context: SpanContext? = nil, attributes: [ObservatoryKeyValue]? = nil, startTimeUnixNano: TimeRepresentable? = nil, linkes:[Link]? = nil, traceState: TraceState? = nil) -> ReadableSpan? {
        return internalCreateSpan(name: name, kind: kind, context: context, attributes: attributes, startTimeUnix: startTimeUnixNano, linkes: linkes, traceState: traceState)
    }
    
    public func createSpan(name: String, kind: SpanKind, parentSpanHex: String, traceHex: String, sample: SamplingDecision, isRemote: Bool, attributes: [ObservatoryKeyValue]? = nil, startTimeUnixNano: TimeRepresentable? = nil, linkes:[Link]? = nil, traceStateRaw: String?) -> ReadableSpan? {
        guard let spanId = SpanID.create(hexString: parentSpanHex),
        let traceId = TraceID.create(hexString: traceHex)
        else {
            return nil
        }
        let traceState = TraceState(raw: traceStateRaw)
        let context = SpanContext(trace: traceId, span: spanId, sampledFlag: sample, isRemote: isRemote, parentSpan: nil, traceState: traceState)
        return internalCreateSpan(name: name, kind: kind, context: context, attributes: attributes, startTimeUnix: startTimeUnixNano, linkes: linkes, traceState: traceState)
    }
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
    
    fileprivate func handleSpanCreation(_ spanContext: SpanContext, _ name: String, _ kind: SpanKind, _ attributes: [ObservatoryKeyValue]?, _ provider: (any AnyObject & TracerProvidable), _ startTimeUnixNano: TimeRepresentable?) -> ReadableSpan? {
        let span = Span(name: name, kind: kind, limit: limit, context: spanContext, attributes: attributes, scope:scope, provider: provider, queue: spanOperateQueue)
        span.startTimeUnix = startTimeUnixNano
        provider.onSpanStarted(span: span)
        return span.readableSpan()
    }
    
    public func internalCreateSpan(name: String, kind: SpanKind, context: SpanContext?, attributes: [ObservatoryKeyValue]?, startTimeUnix: TimeRepresentable?, linkes: [Link]?, traceState: TraceState?) -> ReadableSpan? {
        guard let provider = provider else {
            return nil
        }
        // if there is a context parameter, create span with the parameter context
        if let spanContext = context {
            let spanId = generateSpanID()
            let spanContext = SpanContext(trace: spanContext.traceID, span: spanId, sampledFlag: spanContext.sampledFlag, isRemote: false, parentSpan: spanContext.spanID, traceState: spanContext.traceState)
            return handleSpanCreation(spanContext, name, kind, attributes, provider, startTimeUnix)
        }
        // if current tracer has no context, create a brand new context as the root span of the trace
        let traceId = generateTraceID()
        let spanId = generateSpanID()
        // only originatly created span needs a sampler to decide wether the span should be sampled and recorded
        let sampleResult = provider.shouldSample(traceID: traceId, name: name, parentSpanID: nil, attributes: attributes, links: linkes, traceState: traceState)
        guard sampleResult.decision != .drop else {
            return nil
        }
        let spanContext = SpanContext(trace: traceId, span: spanId, sampledFlag: sampleResult.decision, isRemote: false, parentSpan: nil, traceState: sampleResult.traceState)
        return handleSpanCreation(spanContext, name, kind, attributes, provider, startTimeUnix)
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
        self.provider = provider
    }
}
