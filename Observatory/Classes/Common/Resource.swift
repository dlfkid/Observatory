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
}

