//
//  LoggerProvidable.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol LoggerProvidable {
    func createLoggerIfNeeded(name: String, version: String, schemeaURL: String?, attributes: [String: ObservableValue]?) -> Loggerable
}

class LoggerProvider: LoggerProvidable {
    
    private var loggerCache = [String: Loggerable]()
    
    let timeStampProvider: TimeStampProvidable
    
    func  createLoggerIfNeeded(name: String, version: String) -> Loggerable {
        return createLoggerIfNeeded(name: name, version: version, schemeaURL: nil, attributes: nil)
    }
    
    func createLoggerIfNeeded(name: String, version: String, schemeaURL: String?, attributes: [String : ObservableValue]?) -> Loggerable {
        if let logger = loggerCache[loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)] {
            return logger
        }
        let generatedLoggerKey = loggerCacheKey(name: name, version: version, schemeaURL: schemeaURL)
        let generatedLogger = Logger(version: version, name: name, schemaURL: schemeaURL)
        loggerCache[generatedLoggerKey] = generatedLogger
        return generatedLogger
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

