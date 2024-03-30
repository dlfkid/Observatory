//
//  SimpleSpanProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class SimpleSpanProcessor: SpanProcessable {
    
    public let sampler = SimpleSampler()
    
    public func onSpanStarted(span: Span) {
        let sampleResult = sampler.shouldSample(traceID: span.context.traceID, name: span.name, parentSpanID: span.context.spanID, attributes: [], links: [], traceState: nil)
        switch sampleResult.decision {
        case .drop:
            break
        case .recordOnly:
            break
        case .recordAndSample:
            break
            // unexportedLogRecords.updateValue(span.toSpanData(), forKey: span)
        }
    }
    
    public func onSpanEnded(span: Span) {
        
    }
    
    
    typealias TelemetryData = SpanData
    
    private var shuttedDown: Bool = false
    
    public var exporter: (any TelemetryExportable)?
    
    private var unexportedLogRecords = [InstrumentationScope: SpanData]()
    
    public init(exporter: (any TelemetryExportable)? = nil) {
        self.exporter = exporter
    }
}

extension SimpleSpanProcessor: ProcedureEndable {
    public var isShuttedDown: Bool {
        return shuttedDown
    }
    
    public func shutdown(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        defer {
            shuttedDown = true
        }
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .shuttedDown(component: "SimpleSpanProcessor"))
            return
        }
        exporter?.shutdown(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .shuttedDown(component: "SimpleSpanProcessor"))
            return
        }
        exporter?.forceFlush(timeout: timeout, closure: closure)
    }
    
    
}
