//
//  SimpleLogRecordExporter.swift
//  Observatory
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2023/12/9.
//

import Foundation

public class SimpleLogRecordExporter: LogExportable {
    var shuttedDown = false
    
    public init() {}
}

extension SimpleLogRecordExporter: ProcedureEndable {
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
            closure(false, .shuttedDown(component: "SimpleLogExporter"))
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
    
    public func export(timeout: TimeInterval, batch: [LogRecordData], completion: @escaping (Result<[LogRecordData], ObservatoryError>) -> Void) {
        for record in batch {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional: Make the JSON output more readable
            do {
                let jsonData = try encoder.encode(record)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("[Log Exported]: \(jsonString)")
                }
            } catch {
                print("[Log Exported]: Error encoding JSON: \(error)")
            }
        }
    }
}
