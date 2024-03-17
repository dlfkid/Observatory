//
//  Context.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/25.
//

import Foundation

public protocol Context {
    var traceID: TraceID {get}
    var spanID: SpanID {get}
}

public struct SpanContext: Equatable, Context {
    public static func == (lhs: SpanContext, rhs: SpanContext) -> Bool {
        return lhs.spanID == rhs.spanID && lhs.traceID == rhs.traceID
    }
    
    public let traceID: TraceID
    
    public let spanID: SpanID
    
    public let isRemote: Bool
    
    public let sampledFlag: Int
    
    public init(trace: TraceID, span: SpanID, sampledFlag: Int, isRemote: Bool) {
        self.traceID = trace
        self.spanID = span
        self.sampledFlag = sampledFlag
        self.isRemote = isRemote
    }
}
