//
//  LoggerProvider.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/24.
//

import Foundation


class LoggerProvider: LoggerProvidable {
    
    private var cacheManageQueue = DispatchQueue(label: "com.leondeng.Observatory.cacheManageQueue", qos: .utility)
    
    private var loggerCache = [String: Loggerable]()
    
    private let processorCache: [LogProcessable]
    
    let resource: Resource
    
    let timeStampProvider: TimeStampProvidable
    
    func createLoggerIfNeeded(name: String, version: String) {
        return createLoggerIfNeeded(name: name, version: version, schemeaURL: nil, attributes: nil)
    }
    
    func createLoggerIfNeeded(name: String, version: String, schemeaURL: String?, attributes: [String : ObservableValue]?) {
        cacheManageQueue.sync {
            if let _ = loggerCache[loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)] {
                return
            }
            let generatedLoggerKey = loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)
            let generatedLogger = Logger(version: version, name: name, schemaURL: schemeaURL)
            loggerCache[generatedLoggerKey] = generatedLogger
        }
    }
    
    private func loggerCacheKey(name: String, version: String, schemeaURL: String?) -> String {
        return String("\(name)_\(version)_\(schemeaURL ?? "")")
    }
    
    func log(_ body: String, severity: LogSeverity, timeStamp: TimeInterval?, attributes: [String : ObservableValue]?, traceID: Data?, spanID: Data?, flag: LogRecordFlags, name: String, version: String, schemeaURL: String?) {
        var actualTimeStamp = 0.0
        if let timeStamp = timeStamp {
            actualTimeStamp = timeStamp
        } else {
            actualTimeStamp = timeStampProvider.currentTimeStampMillieSeconds()
        }
        
        if let logger = loggerCache[loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)] {
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
