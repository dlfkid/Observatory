//
//  LoggerProvider.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/24.
//

import Foundation


class LoggerProvider: LoggerProvidable {
    
    private var cacheManageQueue = DispatchQueue(label: "com.leondeng.Observatory.cacheManageQueue.log", qos: .utility)
    
    private var loggerCache = [String: Loggerable]()
    
    private let processorCache: [LogProcessable]
    
    let resource: Resource
    
    let timeStampProvider: TimeStampProvidable
    
    func createLoggerIfNeeded(name: String, version: String) {
        return createLoggerIfNeeded(name: name, version: version, schemaURL: nil, attributes: nil)
    }
    
    func createLoggerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String : ObservatoryValue]?) {
        cacheManageQueue.sync {
            if let _ = loggerCache[createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)] {
                return
            }
            let generatedLoggerKey = createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)
            let generatedLogger = Logger(version: version, name: name, schemaURL: schemaURL)
            loggerCache[generatedLoggerKey] = generatedLogger
        }
    }
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String : ObservatoryValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags, name: String, version: String, schemaURL: String?) {
        var actualTimeStamp = 0.0
        if let timeStamp = timeStamp {
            actualTimeStamp = timeStamp
        } else {
            actualTimeStamp = timeStampProvider.currentTimeStampMillieSeconds()
        }
        
        if let logger = loggerCache[createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)] {
            let record = logger.log(body, severity: severity, timeStamp: actualTimeStamp, attributes: attributes, traceID: traceID, spanID: spanID, flag: flag)
            for processor in processorCache {
                processor.onEmit(logRecord: record)
            }
        }
    }
    
    init(resource: Resource, timeStampProvider: TimeStampProvidable, logProcessors: [LogProcessable]) {
        self.resource = resource
        self.timeStampProvider = timeStampProvider
        self.processorCache = logProcessors
    }
}
