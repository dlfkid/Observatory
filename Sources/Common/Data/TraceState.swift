//
//  File.swift
//  
//
//  Created by LeonDeng on 2024/1/23.
//

import Foundation

public struct TraceState {
    
    private let keyValueList: [[String: String]]
    
    public init(keyValueList: [[String: String]]) {
        self.keyValueList = keyValueList
    }
    
    public func value(key: String) -> String? {
        return keyValueList.first(where: { $0["key"] == key })?[key]
    }
    
    public func append(value: String, key: String) -> TraceState {
        var newKeyValueList = keyValueList
        newKeyValueList.append(["key": key, "value": value])
        return TraceState(keyValueList: newKeyValueList)
    }
    
    public func update(vlaue: String, key: String) -> TraceState {
        var newKeyValueList = keyValueList
        newKeyValueList.removeAll(where: { $0["key"] == key })
        newKeyValueList.append([key: vlaue])
        return TraceState(keyValueList: newKeyValueList)
    }
    
    public func remove(value: String, key: String) -> TraceState {
        var newKeyValueList = keyValueList
        newKeyValueList.removeAll(where: { $0["key"] == key })
        return TraceState(keyValueList: newKeyValueList)
    }
}

public extension TraceState {
    var w3cTraceStateHeader: String {
        return keyValueList.map({ $0.map({ "\($0.key)=\($0.value)" }).joined(separator: ";") }).joined(separator: ",")
    }
    
    init(raw: String?) {
        keyValueList = []
    }
}
