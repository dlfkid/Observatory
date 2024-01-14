//
//  LogRecordProcessor.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol LogProcessable: ProcedureEndable {
    
    var exporter: (any TelemetryExportable)? {get}
    
    func onEmit(logRecord: LogRecordData)
}
