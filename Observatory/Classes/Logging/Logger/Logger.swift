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
    func log(record: LogRecord)
}

class Logger: Loggerable {
    
    func log(record: LogRecord) {
        
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
