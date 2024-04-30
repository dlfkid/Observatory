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
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeRepresentable?, attributes: [String: ObservatoryValue]?, traceID: TraceID?, spanID: SpanID?, flag: LogRecordFlags)
}

class Logger: Loggerable {
    
    private weak var provider: (AnyObject & LoggerProvidable)?
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeRepresentable?, attributes: [String : ObservatoryValue]?, traceID: TraceID?, spanID: SpanID?, flag: LogRecordFlags) {
        var atttributUnits = [ObservatoryKeyValue]()
        attributes?.forEach({ (key: String, value: ObservatoryValue) in
            let unit = ObservatoryKeyValue(key: key, value: value)
            atttributUnits.append(unit)
        })
        let time = timeStamp ?? timeStampProvider?.currentTime()
        let logData = LogRecordData(timeUnix: time, body: body, traceID: traceID, spanID: spanID, severity_text: severity.severityName, severity_number: severity.severityNumber, dropped_attributes_count: 0, attributes: atttributUnits, flags: flag, scope: scope, resource: provider?.resource)
        provider?.onEmit(logRecord: logData)
    }
    
    let version: String
    
    let name: String
    
    let schemaURL: String?
    
    let timeStampProvider: (any TimeStampProvidable)?
    
    internal init(version: String, name: String, schemaURL: String? = nil, timeStampProvider: (any TimeStampProvidable)?, provider: (AnyObject & LoggerProvidable)?) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
        self.timeStampProvider = timeStampProvider
        self.provider = provider
    }
    
}
