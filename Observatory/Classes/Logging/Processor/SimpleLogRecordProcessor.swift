//
//  SimpleLogRecordProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/21.
//

import Foundation

public class SimpleLogProcessor: LogProcessable {
    
    private var shuttedDown: Bool = false
    
    public var exporter: LogExportable?
    
    private var unexportedLogRecords = [InstrumentationScope: LogRecordData]()
    
    public init(exporter: LogExportable? = nil) {
        self.exporter = exporter
    }
    
    public func onEmit(logRecord: LogRecordData) {
        self.exporter?.export(timeout: 10, batch: [logRecord], completion: { result in
        })
    }
}

extension SimpleLogProcessor: ProcedureEndable {
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
            closure(false, .shuttedDown(component: "SimpleLogProcessor"))
            return
        }
        exporter?.shutdown(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .shuttedDown(component: "SimpleLogProcessor"))
            return
        }
        exporter?.forceFlush(timeout: timeout, closure: closure)
    }
    
    
}
