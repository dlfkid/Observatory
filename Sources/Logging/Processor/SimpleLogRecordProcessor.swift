//
//  SimpleLogRecordProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/21.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public class SimpleLogProcessor: LogProcessable {
    
    typealias TelemetryData = LogRecordData
    
    /// this closure will called if the processor needs to inform the user
    public var eventCallBackEmited: ProcedureEndClosure?
    
    private var shuttedDown: Bool = false
    
    public var exporter: (any TelemetryExportable)?
    
    private var unexportedLogRecords = [InstrumentationScope: LogRecordData]()
    
    public init(exporter: (any TelemetryExportable)? = nil) {
        self.exporter = exporter
    }
    
    public func onEmit(logRecord: LogRecordData) {
        self.exporter?.export(resource:logRecord.resource, scope: logRecord.scope, timeout: 10, batch: [logRecord], completion: { result in
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
            closure(false, .alreadyShuttedDown(component: "SimpleLogProcessor"))
            return
        }
        exporter?.shutdown(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .alreadyShuttedDown(component: "SimpleLogProcessor"))
            return
        }
        exporter?.forceFlush(timeout: timeout, closure: closure)
    }
    
    
}
