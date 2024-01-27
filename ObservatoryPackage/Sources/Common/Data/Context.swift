//
//  Context.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/25.
//

import Foundation

public struct Context<T> {
    
    private var internalValues = [String: T]()
    
    public func acquireValue(key: String) -> T? {
        return internalValues[key]
    }
    
    public func attach(_ value:T, key: String) -> Context {
        var newContext = Context()
        newContext.internalValues[key] = value
        return newContext
    }
}

public struct SpanContext: Hashable, Comparable {
    public static func < (lhs: SpanContext, rhs: SpanContext) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
    
    public let trace: TraceID
    
    public let span: SpanID
    
    public let isRemote: Bool
    
    public let sampledFlag: Int
    
    public init(trace: TraceID, span: SpanID, sampledFlag: Int, isRemote: Bool) {
        self.trace = trace
        self.span = span
        self.sampledFlag = sampledFlag
        self.isRemote = isRemote
    }
}
