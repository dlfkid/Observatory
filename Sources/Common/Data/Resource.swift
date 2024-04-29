//
//  Resource.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public struct Resource {
    private let droppedAttribute: Int
    
    private let attributes: [ObservatoryKeyValue]
    
    fileprivate init(droppedAttribute: Int, attributes: [ObservatoryKeyValue]) {
        self.droppedAttribute = droppedAttribute
        self.attributes = attributes
    }
}

public class ResourceBuilder {
    private let serviceNameKey = "service.name"
    private let nameSpaceKey = "service.namespace"
    private let instanceIdKey = "service.instance.id"
    private let versionKey = "service.version"
    
    private var limit = LimitConfig()
    private var attributesDict = [String: ObservatoryValue]()
    private var droppedAttribute: Int = 0
    
    public init() {}
    
    public func serviceName(_ serviceName: String) -> ResourceBuilder {
        attributesDict[serviceNameKey] = .string(serviceName)
        return self
    }
    public func nameSpace(_ nameSpace: String) -> ResourceBuilder {
        attributesDict[nameSpaceKey] = .string(nameSpace)
        return self
    }
    public func instanceId(_ instanceId: String) -> ResourceBuilder {
        attributesDict[instanceIdKey] = .string(instanceId)
        return self
    }
    public func version(_ version: String) -> ResourceBuilder {
        attributesDict[versionKey] = .string(version)
        return self
    }
    public func otherAttributes(_ otherAttributes: [String: ObservatoryValue]) -> ResourceBuilder {
        var attributeCount = 0
        for (key, value) in otherAttributes {
            if let value = attributesDict[key] {
                // if key is already exist, replace the key
                attributesDict[key] = value
                continue
            }
            if attributeCount >= limit.maximumNumberOfAttributes ?? 0 {
                // if the dict is reach its limit, dropp the attribute
                droppedAttribute += 1
                continue
            }
            // add the attribute normally
            attributesDict[key] = value
            attributeCount += 1
        }
        return self
    }
    
    public func build() -> Resource {
        var attributes = [ObservatoryKeyValue]()
        for (key, value) in attributesDict {
            let keyValue = ObservatoryKeyValue(key: key, value: value)
            attributes.append(keyValue)
        }
        return Resource(droppedAttribute: droppedAttribute, attributes: attributes)
    }
}

extension Resource: Encodable {
    enum CodingKeys: String, CodingKey {
        case dropped_attributes_count = "dropped_attributes_count"
        case attributes = "attributes"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(0, forKey: .dropped_attributes_count)
    }
}

