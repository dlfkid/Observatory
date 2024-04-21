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
    var parentSpanID: SpanID? {get}
}
