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
    func log(_ content: String, timeStamp: TimeInterval, severity: Severity, attributes: [String : ObservableValue]?)
}

class Logger: Loggerable {
    
    func log(_ content: String, timeStamp: TimeInterval, severity: Severity, attributes: [String : ObservableValue]?) {
    }
    
    func logDebug(_ content: String, attributes: [String : ObservableValue]?) {
        log(content, timeStamp: Date().timeIntervalSince1970, severity: .debug, attributes: attributes)
    }
    
    func logInfo(_ content: String, attributes: [String : ObservableValue]?) {
        log(content, timeStamp: Date().timeIntervalSince1970, severity: .info, attributes: attributes)
    }
    
    func logWarn(_ content: String, attributes: [String : ObservableValue]?) {
        log(content, timeStamp: Date().timeIntervalSince1970, severity: .warn, attributes: attributes)
    }
    
    func logError(_ content: String, attributes: [String : ObservableValue]?) {
        log(content, timeStamp: Date().timeIntervalSince1970, severity: .error, attributes: attributes)
    }
    
    func logFatal(_ content: String, attributes: [String : ObservableValue]?) {
        log(content, timeStamp: Date().timeIntervalSince1970, severity: .fatal, attributes: attributes)
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
