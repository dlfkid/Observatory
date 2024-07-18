//
//  CompositSpanProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2024/4/13.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class CompositSpanProcessor: SpanProcessable {
    public typealias Exporter = SimpleSpanExporter
    
    public let exporter: SimpleSpanExporter? = nil
    
    /// this closure will called if the processor needs to inform the user
    public var eventCallBackEmited: ProcedureEndClosure?
    
    var shuttedDown: Bool = false
    
    let processors: [any SpanProcessable]
    
    init(processors: [any SpanProcessable]) {
        self.processors = processors
    }
    
    public func onSpanStarted(span: Span) {
        if isShuttedDown {
            return
        }
        processors.forEach { processor in
            processor.onSpanStarted(span: span)
        }
    }
    
    public func onSpanEnded(span: Span) {
        if isShuttedDown {
            return
        }
        processors.forEach { processor in
            processor.onSpanEnded(span: span)
        }
    }
    
    public var isShuttedDown: Bool {
        return shuttedDown
    }
    
    public func shutdown(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        processors.forEach { processor in
            processor.shutdown(timeout: timeout, closure: closure)
        }
        shuttedDown = false
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if isShuttedDown {
            return
        }
        processors.forEach { processor in
            processor.forceFlush(timeout: timeout, closure: closure)
        }
    }
}
