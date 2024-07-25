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
    
    /// this closure will called if the processor needs to inform the user
    public var eventCallBackEmited: ProcedureEndClosure?
    
    /// the maximum number of span the cachePool can contain
    public var maximumCacheCount: Int = 128
    
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
            if self.spanPool.count > self.maximumCacheCount {
                self.executeEventEmitCallback(ret: false, event: ObservatoryError.limitReached(msg: "SpanCachePool has reached the maximum cache count"))
                return
            }
            self.spanPool[span.context.spanID] = span
            self.executeEventEmitCallback(ret: true, event: ObservatoryError.normal(msg: "SpanName: \(span.name) \ntraceId: \(span.context.traceID.hexString) \nspanId: \(span.context.spanID.hexString)\n is cached in cache pool"))
        }
    }
    
    public func onSpanEnded(span: Span) {
        poolFetchQueue.async {
            self.spanPool.removeValue(forKey: span.context.spanID)
            self.executeEventEmitCallback(ret: true, event: ObservatoryError.normal(msg: "SpanName: \(span.name) \ntraceId: \(span.context.traceID.hexString) \nspanId: \(span.context.spanID.hexString) \nhas removed frome cache pool"))
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
        defer {
            shuttedDown = true
        }
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .alreadyShuttedDown(component: "SpanCachePool"))
            return
        }
        poolFetchQueue.async {
            self.spanPool.removeAll()
            guard let closure = closure else {
                return
            }
            DispatchQueue.main.async {
                closure(true, .normal(msg: "SpanCachePool"))
            }
        }
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        poolFetchQueue.async {
            self.spanPool.removeAll()
            guard let closure = closure else {
                return
            }
            DispatchQueue.main.async {
                closure(true, .normal(msg: "SpanCachePool"))
            }
        }
    }
}
