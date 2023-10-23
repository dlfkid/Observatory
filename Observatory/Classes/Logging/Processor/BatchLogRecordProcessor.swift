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
    
    public func onEmit(logRecord: LogRecordData) {
        
    }
    
    public var exporter: LogExportable?
    
    private let config: BatchLogRecordConfig
    
    private var unexportedLogRecords = [InstrumentationScope: LogRecordData]()
    
    init(config: BatchLogRecordConfig) {
        self.config = config
        self.exporter = config.exporter
    }
}
