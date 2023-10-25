//
//  Context.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/25.
//

import Foundation

struct Context: Hashable, Comparable {
    static func < (lhs: Context, rhs: Context) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
    
    let trace: TraceID
    
    let span: SpanID
}
