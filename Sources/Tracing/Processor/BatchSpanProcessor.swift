//
//  BatchSpanProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public struct BatchSpanProcessorConfig {
    
    /// The maximum number of spans to batch together in a single export.
    public let spansPerBatch: Int
    
    /// The maximum total size of the batched spans.
    public let scheduleDelay: TimeInterval
    
    /// The maximum time to wait for the batch to reach either spansPerBatch or scheduleDelay
    public let exportTimeout: TimeInterval
    
    /// To prevent memory inflation the batch will be flushed if it reaches this size.
    public let maximumBatchSize: Int
    
    public static func `default`() -> BatchSpanProcessorConfig {
        return BatchSpanProcessorConfig(spansPerBatch: 10, scheduleDelay: 15, exportTimeout: 6, maximumBatchSize: 128)
    }
}

public class BatchSpanProcessor: SpanProcessable {
    
    public typealias Exporter = SimpleSpanExporter
    
    public typealias TelemetryData = SpanData
    
    public var exporter: SimpleSpanExporter?
    
    private lazy var spanDataBatch: [SpanData] = {
        return [SpanData]()
    }()
    
    private let operateQueue = DispatchQueue(label: "com.span_batch.observatory", qos: .utility)
    
    private var shuttedDown: Bool = false
    
    private let config: BatchSpanProcessorConfig
    
    public var isShuttedDown: Bool {
        return shuttedDown
    }
    
    private var timer: DispatchSourceTimer?
    
    deinit {
        timerStop()
    }
    
    init(exporter: SimpleSpanExporter, config: BatchSpanProcessorConfig = .default()) {
        self.exporter = exporter
        self.config = config
        timerStart()
    }
    
    private func timerStart() {
        let timer = DispatchSource.makeTimerSource(queue: operateQueue)
        timer.schedule(deadline: .now(), repeating: config.scheduleDelay)
        timer.setEventHandler { [weak self] in
            guard let self = self else {
                return
            }
            self.operateQueue.async {
                var batch = [SpanData]()
                while batch.count <= self.config.spansPerBatch {
                    guard let spanData = self.spanDataBatch.popLast() else {
                        break
                    }
                    batch.append(spanData)
                }
                self.exporter?.export(timeout: self.config.exportTimeout, batch: batch, completion: { result in
                    switch result {
                    case let .success(spanDataBatch):
                        print(spanDataBatch)
                    case let .failure(error):
                        print(error)
                    }
                })
            }
        }
        self.timer = timer
    }
    
    private func timerStop() {
        timer?.cancel()
    }
    
    public func shutdown(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        defer {
            
            
            shuttedDown = true
        }
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .alreadyShuttedDown(component: "SimpleSpanProcessor"))
            return
        }
        exporter?.shutdown(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        
    }
    
    public func onSpanStarted(span: Span) {
        
    }
    
    public func onSpanEnded(span: Span) {
        guard span.context.sampledFlag == .recordAndSample else {
            return
        }
        let spanData = SpanData.spanData(from: span)
        operateQueue.async {
            guard self.spanDataBatch.count < self.config.maximumBatchSize else {
                return
            }
            self.spanDataBatch.insert(spanData, at: 0)
        }
    }
}
