//
//  TraceProvider.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class TracerProvider: TracerProvidable {
    
    private let limit: SpanLimit
    
    private let sampler: any Samplerable
    
    public func createTracerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String : ObservatoryValue]?) -> Tracerable {
        cacheManageQueue.sync {
            if let tracer = tracerCache[createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)] {
                return tracer
            }
            let generatedTracerKey = self.createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)
            let generatedTracer = Tracer(version: version, name: name, schemaURL: schemaURL, limit: limit, provider: self)
            tracerCache[generatedTracerKey] = generatedTracer
            return generatedTracer
        }
    }
    
    public func onSpanStarted(span: Span) {
        self.processorManageQueue.async {
            self.processorCache.forEach { processor in
                if span.startTimeUnix == nil {
                    span.startTimeUnix = self.timeStampProvider.currentTime()
                }
                span.resource = self.resource
                processor.onSpanStarted(span: span)
            }
        }
    }
    
    public func onSpanEnded(span: Span) {
        self.processorManageQueue.async {
            self.processorCache.forEach { processor in
                if span.endTimeUnix == nil {
                    span.endTimeUnix = self.timeStampProvider.currentTime()
                }
                processor.onSpanEnded(span: span)
            }
        }
    }
    
    public func shouldSample(traceID: TraceID, name: String, parentSpanID: SpanID?, attributes: [ObservatoryKeyValue]?, links: [Link]?, traceState: TraceState?) -> SamplingResult {
        return sampler.shouldSample(traceID: traceID, name: name, parentSpanID: parentSpanID, attributes: attributes, links: links, traceState: traceState)
    }
    
    private var cacheManageQueue = DispatchQueue(label: "com.leondeng.Observatory.cacheManageQueue.trace", qos: .utility)
    
    private var processorManageQueue = DispatchQueue(label: "com.leondeng.Observatory.processorManageQueue.trace", qos: .utility)
    
    private var tracerCache = [String: Tracerable]()
    
    private let processorCache: [any SpanProcessable]
    
    let resource: Resource
    
    public let timeStampProvider: any TimeStampProvidable
    
    internal init(resource: Resource, limit: SpanLimit, timeStampProvider: any TimeStampProvidable, processors: [any SpanProcessable], sampler: any Samplerable) {
        self.resource = resource
        self.timeStampProvider = timeStampProvider
        self.processorCache = processors
        self.limit = limit
        self.sampler = sampler
    }
}
