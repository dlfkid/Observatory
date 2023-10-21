//
//  LogRecordProcessor.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol LogProcessable {
    var exporter: LogExportable? {get set}
    
    func addLogRecord(_ logRecordData: LogRecordData, scope: InstrumentationScope)
}
