//
//  Logger.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

/*
 Timestamp
 Observed Timestamp. If unspecified the implementation SHOULD set it equal to the current time.
 The Context associated with the LogSeverity. The API MAY implicitly use the current Context as a default behavior.
 Severity Number
 Severity Text
 Body
 Attributes
 */

public protocol Loggerable: Scopable {
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String: ObservatoryValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags)
}

class Logger: Loggerable {
    
    private weak var provider: (AnyObject & LoggerProvidable)?
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String : ObservatoryValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags) {
        var atttributUnits = [ObservatoryKeyValue]()
        attributes?.forEach({ (key: String, value: ObservatoryValue) in
            let unit = ObservatoryKeyValue(key: key, value: value)
            atttributUnits.append(unit)
        })
        let time = timeStamp ?? timeStampProvider.currentTimeStampMillieSeconds()
        let logData = LogRecordData(time_unix_nano: time, body: body, trace_id: traceID, span_id: spanID, severity_text: severity.severityName, severity_number: severity.severityNumber, dropped_attributes_count: 0, attributes: atttributUnits, flags: flag, scope: scope, resource: provider?.resource)
        provider?.onEmit(logRecord: logData)
    }
    
    let version: String
    
    let name: String
    
    let schemaURL: String?
    
    let timeStampProvider: TimeStampProvidable
    
    internal init(version: String, name: String, schemaURL: String? = nil, timeStampProvider: TimeStampProvidable, provider: (AnyObject & LoggerProvidable)?) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
        self.timeStampProvider = timeStampProvider
        self.provider = provider
    }
    
}
