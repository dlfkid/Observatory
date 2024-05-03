//
//  SimpleSpanProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class SimpleSpanProcessor<T: TelemetryExportable>: SpanProcessable {
    
    public typealias Exporter = T
    
    public var debugOutPutHandler: ((_ event: ObservatoryError)-> Void)?
    
    public func onSpanStarted(span: Span) {
        if let debugOutPutHandler = debugOutPutHandler {
            debugOutPutHandler(.normal(msg: "\(span.name) started \n traceId: \(span.context.traceID.hexString) \n spanId: \(span.context.spanID.hexString)"))
        }
    }
    
    public func onSpanEnded(span: Span) {
        if let debugOutPutHandler = debugOutPutHandler {
            debugOutPutHandler(.normal(msg: "\(span.name) ended \n traceId: \(span.context.traceID.hexString) \n spanId: \(span.context.spanID.hexString)"))
        }
        guard span.context.sampledFlag == .recordAndSample else {
            return
        }
        let spanData = SpanData.spanData(from: span)
        exporter?.export(resource:spanData.resource, scope: spanData.scope, timeout: 15, batch: [spanData], completion: { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Failed to export span data: \(error.localizedDescription)")
            }
        })
    }
    
    
    typealias TelemetryData = SpanData
    
    private var shuttedDown: Bool = false
    
    public var exporter: Exporter?
    
    private var unexportedLogRecords = [InstrumentationScope: SpanData]()
    
    public init(exporter: Exporter? = nil) {
        self.exporter = exporter
    }
    
    internal init() {}
}

extension SimpleSpanProcessor: ProcedureEndable {
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
            closure(false, .alreadyShuttedDown(component: "SimpleSpanProcessor"))
            return
        }
        exporter?.shutdown(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .alreadyShuttedDown(component: "SimpleSpanProcessor"))
            return
        }
        exporter?.forceFlush(timeout: timeout, closure: closure)
    }
    
    
}
