//
//  LogRecordProcessor.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol LogProcessable: ProcedureEndable {
    
    var exporter: LogExportable? {get}
    
    func onEmit(logRecord: LogRecordData)
}
