//
//  LoggerProviderBuilder.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public struct LoggerProviderBuilder {
    let resource: Resource
    
    public func build() -> LoggerProvidable {
        return LoggerProvider(resource: resource)
    }
}
