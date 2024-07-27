//
//  TracingProvidable.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public protocol TracerProvidable: CachedKeyManagable {
    
    var timeStampProvider: any TimeStampProvidable {get}
    
    func createTracerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String: ObservatoryValue]?) -> Tracerable
    
    func onSpanStarted(span: Span)
    
    func onSpanEnded(span: Span)
    
    func shouldSample(traceID: TraceID, name: String, parentSpanID: SpanID?, attributes: [ObservatoryKeyValue]?, links: [Link]?, traceState: TraceState?) -> SamplingResult
    
    /// Acquire the recent created tracer by this provider
    /// - Returns: Tracerable
    func recentTracer() -> Tracerable?
}

extension TracerProvidable {
    public func recentTracer() -> Tracerable? {
        return nil
    }
}

