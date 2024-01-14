//
//  TraceProviderBuilder.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public class TracerProviderBuilder {
    private let resource: Resource
    
    public var timeStampProvider: TimeStampProvidable = TimeStampProvider()
    
    public var spanProcessables = [SpanProcessable]()
    
    public init(resource: Resource) {
        self.resource = resource
    }
    
    public func addTimeStampProvider(_ provider: TimeStampProvidable) -> TracerProviderBuilder {
        timeStampProvider = provider
        return self
    }
    
    public func addLogProcessable(_ processor: SpanProcessable) -> TracerProviderBuilder {
        spanProcessables.append(processor)
        return self
    }
    
    public func build() -> Any & TracerProvidable {
        return TracerProvider(resource: resource, timeStampProvider: timeStampProvider, processors: spanProcessables)
    }
}
