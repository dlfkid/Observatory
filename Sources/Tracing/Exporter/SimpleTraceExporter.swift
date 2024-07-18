//
//  SimpleTraceExporter.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class SimpleSpanExporter: TelemetryExportable {
    public typealias TelemetryData = SpanData
    
    /// this closure will called if the processor needs to inform the user
    public var eventCallBackEmited: ProcedureEndClosure?
    
    var shuttedDown = false
    
    public init() {}
}

extension SimpleSpanExporter: ProcedureEndable {
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
            closure(false, .alreadyShuttedDown(component: "SimpleSpanExporter"))
            return
        }
        forceFlush(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        guard let closure = closure else {
            return
        }
        closure(true, nil)
    }
    
    public func export<TelemetryData>(resource:Resource?, scope: InstrumentationScope?, timeout: TimeInterval, batch: [TelemetryData], completion: @escaping (Result<[TelemetryData], ObservatoryError>) -> Void) where TelemetryData : Encodable {
        for record in batch {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional: Make the JSON output more readable
            do {
                let jsonData = try encoder.encode(record)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("[Span Exported]: \(jsonString)")
                }
            } catch {
                print("[Span Exported]: Error encoding JSON: \(error)")
            }
        }
    }
}
