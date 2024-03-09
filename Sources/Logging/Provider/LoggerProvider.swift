//
//  LoggerProvider.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/24.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif


class LoggerProvider: LoggerProvidable {
    
    private var cacheManageQueue = DispatchQueue(label: "com.leondeng.Observatory.cacheManageQueue.log", qos: .utility)
    
    private var loggerCache = [String: Loggerable]()
    
    private let processorCache: [LogProcessable]
    
    private let resource: Resource
    
    private let timeStampProvider: TimeStampProvidable
    
    func createLoggerIfNeeded(name: String, version: String) -> Loggerable? {
        return createLoggerIfNeeded(name: name, version: version, schemaURL: nil, attributes: nil)
    }
    
    func createLoggerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String : ObservatoryValue]?) -> Loggerable? {
        
        cacheManageQueue.sync {
            if let logger = loggerCache[createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)] {
                return logger
            }
            let generatedLoggerKey = createInstrumentScopeCachedKey(name: name, version: version, schemaURL: schemaURL)
            let generatedLogger = Logger(version: version, name: name, schemaURL: schemaURL, timeStampProvider: timeStampProvider, provider: self)
            loggerCache[generatedLoggerKey] = generatedLogger
            return generatedLogger
        }
    }
    
    func onEmit(logRecord: LogRecordData) {
        processorCache.forEach { processor in
            processor.onEmit(logRecord: logRecord)
        }
    }
    
    internal init(resource: Resource, timeStampProvider: TimeStampProvidable, logProcessors: [LogProcessable]) {
        self.resource = resource
        self.timeStampProvider = timeStampProvider
        self.processorCache = logProcessors
    }
}
