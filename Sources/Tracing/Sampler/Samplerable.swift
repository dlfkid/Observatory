//
//  File.swift
//  
//
//  Created by LeonDeng on 2024/1/23.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public enum SamplingDecision {
    /// DROP - IsRecording will be false, the Span will not be recorded and all events and attributes will be dropped.
    case drop
    /// RECORD_ONLY - IsRecording will be true, but the Sampled flag MUST NOT be set.
    case recordOnly
    /// RECORD_AND_SAMPLE - IsRecording will be true and the Sampled flag MUST be set.
    case recordAndSample
}

public struct SamplingResult {
    /// A sampling Decision
    public let decision: SamplingDecision
    /// A set of span Attributes that will also be added to the Span
    public let attributes: [ObservatoryKeyValue]?
    
    public let traceState: TraceState?
    
    init(decision: SamplingDecision) {
        self.decision = decision
        self.attributes = nil
        self.traceState = nil
    }
    
    init(decision: SamplingDecision, attributes: [ObservatoryKeyValue]) {
        self.decision = decision
        self.attributes = attributes
        self.traceState = nil
    }
    
    init(decision: SamplingDecision, traceState: TraceState) {
        self.decision = decision
        self.attributes = nil
        self.traceState = traceState
    }
}

public protocol Samplerable {
    func shouldSample(traceID: TraceID, name: String, parentSpanID: SpanID?, attributes: [ObservatoryKeyValue]?, links: [Link]?, traceState: TraceState?) -> SamplingResult
}

public struct SimpleSampler: Samplerable {
    
    public func shouldSample(traceID: TraceID, name: String, parentSpanID: SpanID?, attributes: [ObservatoryKeyValue]?, links: [Link]?, traceState: TraceState?) -> SamplingResult {
        return SamplingResult(decision: .recordAndSample)
    }
    
    
}
