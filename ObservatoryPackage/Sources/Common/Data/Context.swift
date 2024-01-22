//
//  Context.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/25.
//

import Foundation

public struct Context: Hashable, Comparable {
    public static func < (lhs: Context, rhs: Context) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
    
    public let trace: TraceID
    
    public let span: SpanID
    
    init(trace: TraceID, span: SpanID) {
        self.trace = trace
        self.span = span
    }
}
