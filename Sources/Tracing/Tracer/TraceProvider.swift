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
                if span.startTimeUnixNano == 0 {
                    span.startTimeUnixNano = self.timeStampProvider.currentTimeStampMillieSeconds()
                }
                processor.onSpanEnded(span: span)
            }
        }
    }
    
    public func onSpanEnded(span: Span) {
        self.processorManageQueue.async {
            self.processorCache.forEach { processor in
                if span.endTimeUnixNano == 0 {
                    span.endTimeUnixNano = self.timeStampProvider.currentTimeStampMillieSeconds()
                }
                processor.onSpanEnded(span: span)
            }
        }
    }
    
    private var cacheManageQueue = DispatchQueue(label: "com.leondeng.Observatory.cacheManageQueue.trace", qos: .utility)
    
    private var processorManageQueue = DispatchQueue(label: "com.leondeng.Observatory.processorManageQueue.trace", qos: .utility)
    
    private var tracerCache = [String: Tracerable]()
    
    private let processorCache: [SpanProcessable]
    
    let resource: Resource
    
    let timeStampProvider: TimeStampProvidable
    
    internal init(resource: Resource, limit: SpanLimit, timeStampProvider: TimeStampProvidable, processors: [SpanProcessable]) {
        self.resource = resource
        self.timeStampProvider = timeStampProvider
        self.processorCache = processors
        self.limit = limit
    }
}
