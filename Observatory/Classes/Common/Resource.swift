//
//  Resource.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public struct Resource {
    
    private let serviceNameKey = "service.name"
    
    private let nameSpaceKey = "service.namespace"
    
    private let instanceIdKey = "service.instance.id"
    
    private let versionKey = "service.version"
    
    var serviceName: String?
    var nameSpace: String?
    var instanceId: String?
    var version: String?
    var otherAttributes: [String: ObservableValue]?
    
    var metaData: [String: ObservableValue] {
        var result = [String: ObservableValue]()
        if let otherAttributes = otherAttributes {
            otherAttributes.forEach { (key: String, value: ObservableValue) in
                result[key] = value
            }
        }
        result[serviceNameKey] = .string(serviceName ?? "")
        result[nameSpaceKey] = .string(nameSpace ?? "")
        result[instanceIdKey] = .string(instanceId ?? "")
        result[versionKey] = .string(version ?? "")
        return result
    }
    
    public init(serviceName: String? = nil, nameSpace: String? = nil, instanceId: String? = nil, version: String? = nil, otherAttributes: [String : ObservableValue]? = nil) {
        self.serviceName = serviceName
        self.nameSpace = nameSpace
        self.instanceId = instanceId
        self.version = version
        self.otherAttributes = otherAttributes
    }
}

public class ResourceBuilder {
    var limit = LimitConfig()
    var resourceSample = Resource()
    
    func limit(_ limit: LimitConfig) -> ResourceBuilder {
        self.limit = limit
        return self
    }
    
    func serviceName(_ serviceName: String) -> ResourceBuilder {
        resourceSample.serviceName = serviceName
        return self
    }
    func nameSpace(_ nameSpace: String) -> ResourceBuilder {
        resourceSample.nameSpace = nameSpace
        return self
    }
    func instanceId(_ instanceId: String) -> ResourceBuilder {
        resourceSample.instanceId = instanceId
        return self
    }
    func version(_ version: String) -> ResourceBuilder {
        resourceSample.version = version
        return self
    }
    func otherAttributes(_ otherAttributes: [String: ObservableValue]) -> ResourceBuilder {
        var attributeCount = 0
        for (key, value) in otherAttributes {
            if attributeCount >= limit.maximumNumberOfAttributes ?? 0 {
                // dropped attribute
                continue
            }
            resourceSample.otherAttributes?[key] = value
            attributeCount += 1
        }
        return self
    }
}

