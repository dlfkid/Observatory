//
//  LoggerProviderBuilder.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public class LoggerProviderBuilder {
    private let resource: Resource
    
    public var timeStampProvider: TimeStampProvidable = TimeStampProvider()
    
    public init(resource: Resource) {
        self.resource = resource
    }
    
    public func addTimeStampProvider(_ provider: TimeStampProvidable) -> LoggerProviderBuilder {
        timeStampProvider = provider
        return self
    }
    
    public func build() -> Any & LoggerProvidable {
        return LoggerProvider(resource: resource, timeStampProvider: timeStampProvider)
    }
}
