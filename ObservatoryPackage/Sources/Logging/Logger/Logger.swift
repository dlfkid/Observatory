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

public protocol Loggerable {
    
    var version: String {get}
    
    var name: String {get}
    
    var schemaURL: String? {get}
    
    @discardableResult
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String: ObservatoryValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags) -> LogRecordData
}

extension Loggerable {
    var scope: InstrumentationScope {
        return InstrumentationScope(name: name, version: version)
    }
}

struct Logger: Loggerable {
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String : ObservatoryValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags) -> LogRecordData {
        let scope = InstrumentationScope(name: name, version: version)
        var atttributUnits = [ObservatoryKeyValue]()
        attributes?.forEach({ (key: String, value: ObservatoryValue) in
            let unit = ObservatoryKeyValue(key: key, value: value)
            atttributUnits.append(unit)
        })
        let time = timeStamp ?? timeStampProvider.currentTimeStampMillieSeconds()
        let logData = LogRecordData(time_unix_nano: time, body: body, trace_id: traceID, span_id: spanID, severity_text: severity.severityName, severity_number: severity.severityNumber, dropped_attributes_count: 0, attributes: atttributUnits, flags: flag, scope: scope)
        return logData
    }
    
    let version: String
    
    let name: String
    
    let schemaURL: String?
    
    let timeStampProvider: TimeStampProvidable
    
    init(version: String, name: String, schemaURL: String? = nil, timeStampProvider: TimeStampProvidable) {
        self.version = version
        self.name = name
        self.schemaURL = schemaURL
        self.timeStampProvider = timeStampProvider
    }
    
}
