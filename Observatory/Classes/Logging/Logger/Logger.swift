//
//  Logger.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

/*
 Timestamp
 Observed Timestamp. If unspecified the implementation SHOULD set it equal to the current time.
 The Context associated with the LogRecord. The API MAY implicitly use the current Context as a default behavior.
 Severity Number
 Severity Text
 Body
 Attributes
 */

public protocol Loggerable {
    func log(record: LogRecord) -> LogRecordData
}

class Logger: Loggerable {
    
    func log(record: LogRecord) -> LogRecordData {
        return LogRecordData(time_unix_nano: 0, body: nil, trace_id: nil, span_id: nil, severity_text: nil, severity_number: nil, dropped_attributes_count: nil, attributes: nil, flags: .unspecified)
    }
    
    let version: String
    
    let name: String
    
    let schemaURL: String?
    
    init(version: String, name: String, schemaURL: String?) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
    }
    
    
    
}
