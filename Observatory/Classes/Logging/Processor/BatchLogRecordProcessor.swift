//
//  BatchLogRecordProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/21.
//

import Foundation

public struct BatchLogRecordConfig {
    
    let exporter: LogExportable?
    
    var maxQueueSize: Int = 2048
    
    var scheduledDelayMillis: TimeInterval = 1000
    
    var exportTimeoutMillis: TimeInterval = 300000
    
    var maxExportBatchSize: Int = 512
}

public class BatchLogRecordProcessor: LogProcessable {
    
    let config: BatchLogRecordConfig
    
    public var exporter: LogExportable?
    
    public func addLogRecord(_ logRecordData: LogRecordData, scope: InstrumentationScope) {
        
    }
    
    init(config: BatchLogRecordConfig) {
        self.config = config
        self.exporter = config.exporter
    }
}
