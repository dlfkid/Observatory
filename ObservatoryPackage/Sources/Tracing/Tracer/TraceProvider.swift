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
    
    public func createTracerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String : ObservatoryValue]?) {
        cacheManageQueue.sync {
            if let _ = tracerCache[createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)] {
                return
            }
            let generatedLoggerKey = self.createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)
            let generatedLogger = Tracer(version: version, name: name, schemaURL: schemaURL, limit: limit)
            tracerCache[generatedLoggerKey] = generatedLogger
        }
    }
    
    private var cacheManageQueue = DispatchQueue(label: "com.leondeng.Observatory.cacheManageQueue.trace", qos: .utility)
    
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
