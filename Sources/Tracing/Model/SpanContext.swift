//
//  File.swift
//  
//
//  Created by Ravendeng on 2024/4/21.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public struct SpanContext: Equatable, Context {
    public static func == (lhs: SpanContext, rhs: SpanContext) -> Bool {
        return lhs.spanID == rhs.spanID && lhs.traceID == rhs.traceID
    }
    
    public let traceID: TraceID
    
    public let spanID: SpanID
    
    public let parentSpanID: SpanID?
    
    public let isRemote: Bool
    
    public let sampledFlag: SamplingDecision
    
    public let traceState: TraceState?
    
    public init(trace: TraceID, span: SpanID, sampledFlag: SamplingDecision, isRemote: Bool, parentSpan: SpanID?, traceState: TraceState?) {
        self.traceID = trace
        self.spanID = span
        self.sampledFlag = sampledFlag
        self.isRemote = isRemote
        self.parentSpanID = parentSpan
        self.traceState = traceState
    }
}
