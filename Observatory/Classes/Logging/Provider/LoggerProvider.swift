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
    
    let timeStampProvider: TimeStampProvidable
    
    func createLoggerIfNeeded(name: String, version: String) -> Loggerable {
        return createLoggerIfNeeded(name: name, version: version, schemeaURL: nil, attributes: nil)
    }
    
    func createLoggerIfNeeded(name: String, version: String, schemeaURL: String?, attributes: [String : ObservableValue]?) -> Loggerable {
        var result: Loggerable?
        cacheManageQueue.sync {
            if let logger = loggerCache[loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)] {
                result = logger
            }
            let generatedLoggerKey = loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)
            let generatedLogger = Logger(version: version, name: name, schemaURL: schemeaURL)
            loggerCache[generatedLoggerKey] = generatedLogger
            result = generatedLogger
            return
        }
        return result!
    }
    
    func loggerCacheKey(name: String, version: String, schemeaURL: String?) -> String {
        return String("\(name)_\(version)_\(schemeaURL ?? "")")
    }
    
    
    let resource: Resource
    
    init(resource: Resource, timeStampProvider: TimeStampProvidable) {
        self.resource = resource
        self.timeStampProvider = timeStampProvider
    }
}
