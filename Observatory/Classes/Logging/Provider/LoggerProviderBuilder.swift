//
//  LoggerProviderBuilder.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public class LoggerProviderBuilder {
    let resource: Resource
    
    var timeStampProvider: TimeStampProvidable = TimeStampProvider()
    
    init(resource: Resource, timeStampProvider: TimeStampProvidable ) {
        self.resource = resource
        self.timeStampProvider = timeStampProvider
    }
    
    func addTimeStampProvider(_ provider: TimeStampProvidable) -> LoggerProviderBuilder {
        timeStampProvider = provider
        return self
    }
    
    public func build() -> LoggerProvidable {
        return LoggerProvider(resource: resource, timeStampProvider: timeStampProvider)
    }
}
