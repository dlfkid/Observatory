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
 The Context associated with the LogSeverity. The API MAY implicitly use the current Context as a default behavior.
 Severity Number
 Severity Text
 Body
 Attributes
 */

public protocol Loggerable {
    
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval, attributes: [String: ObservableValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags) -> (LogRecordData, InstrumentationScope)
}

extension Loggerable {
    var scope: InstrumentationScope {
        return InstrumentationScope(name: name, version: version)
    }
}

class Logger: Loggerable {
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval, attributes: [String : ObservableValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags) -> (LogRecordData, InstrumentationScope) {
        
        let logData = LogRecordData(time_unix_nano: timeStamp, body: body.data(using: .utf8), trace_id: traceID, span_id: spanID, severity_text: severity.severityName, severity_number: severity.severityNumber, dropped_attributes_count: 0, attributes: attributes, flags: flag)
        
        return (logData, scope)
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
