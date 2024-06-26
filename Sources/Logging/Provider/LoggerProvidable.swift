//
//  LoggerProvidable.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif
import Foundation

public protocol LoggerProvidable: CachedKeyManagable {
    
    var resource: Resource {get}
    
    func createLoggerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String: ObservatoryValue]?) -> Loggerable?
    
    func onEmit(logRecord: LogRecordData)
}

