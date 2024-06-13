//
//  SpanCachePool.swift
//  Observatory
//
//  Created by Ravendeng on 2024/4/11.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class SpanCachePool {
    public static let `default` = SpanCachePool()
    
    public var debugOutPutHandler: ((_ event: ObservatoryError)-> Void)?
    
    private var shuttedDown: Bool = false
    
    private var spanPool = [SpanID: Span]()
    
    private let poolFetchQueue: DispatchQueue = DispatchQueue(label: "SpanCachePoolFetchQueue", qos: .default)
}

extension SpanCachePool: SpanProcessable {
    
    public typealias Exporter = SimpleSpanExporter
    
    public var exporter: Exporter? {
        return nil
    }
    
    public func onSpanStarted(span: Span) {
        poolFetchQueue.async {
            self.spanPool[span.context.spanID] = span
            if let handler = self.debugOutPutHandler {
                handler(ObservatoryError.normal(msg: "SpanName: \(span.name) \ntraceId: \(span.context.traceID.hexString) \nspanId: \(span.context.spanID.hexString)\n is cached in cache pool"))
            }
        }
    }
    
    public func onSpanEnded(span: Span) {
        poolFetchQueue.async {
            self.spanPool.removeValue(forKey: span.context.spanID)
            if let handler = self.debugOutPutHandler {
                handler(ObservatoryError.normal(msg: "SpanName: \(span.name) \ntraceId: \(span.context.traceID.hexString) \nspanId: \(span.context.spanID.hexString) \nhas removed frome cache pool"))
            }
        }
    }
    
    public func fetchReadableSpan(_ spanId: SpanID, resultHandle: @escaping (ReadableSpan?) -> Void) {
        poolFetchQueue.async {
            let span = self.spanPool[spanId]
            resultHandle(span?.readableSpan())
        }
    }
    
    public var isShuttedDown: Bool {
        return shuttedDown
    }
    
    public func shutdown(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        shuttedDown = true
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if let closure = closure {
            closure(true, nil)
        }
    }
}
