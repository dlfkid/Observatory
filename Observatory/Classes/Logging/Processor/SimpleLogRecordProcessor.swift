//
//  SimpleLogRecordProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/21.
//

import Foundation

public class SimpleLogProcessor: LogProcessable {
    public var exporter: LogExportable?
    
    private var unexportedLogRecords = [InstrumentationScope: LogRecordData]()
    
    init(exporter: LogExportable? = nil) {
        self.exporter = exporter
    }
    
    public func onEmit(logRecord: LogRecordData) {
        
    }
}
