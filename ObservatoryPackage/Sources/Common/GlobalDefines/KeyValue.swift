//
//  KeyValue.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/7.
//

import Foundation

public struct ObservatoryKeyValue: Encodable {
    
    enum ObservatoryKeyValueCodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
    }
    
    let key: String
    let value: ObservatoryValue
    
    public init(key: String, value: ObservatoryValue) {
        self.key = key
        self.value = value
    }
}

public enum ObservatoryValue {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case stringArray([String])
    case boolArray([Bool])
    case intArray([Int])
    case doubleArray([Double])
}

extension ObservatoryValue: Encodable {
    
    enum ObservatoryValueCodingKeys: String, CodingKey {
        case string_value = "string_value"
        case int_value = "int_value"
        case double_value = "double_value"
        case bool_value = "bool_value"
        case stringArray = "stringArray"
        case boolArray = "boolArray"
        case intArray = "intArray"
        case doubleArray = "doubleArray"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ObservatoryValueCodingKeys.self)
        switch self {
        case .string(let value):
            try container.encode(value, forKey: .string_value)
        case .int(let value):
            try container.encode(value, forKey: .int_value)
        case .double(let value):
            try container.encode(value, forKey: .double_value)
        case .bool(let value):
            try container.encode(value, forKey: .bool_value)
        case .stringArray(let value):
            try container.encode(value, forKey: .stringArray)
        case .boolArray(let value):
            try container.encode(value, forKey: .boolArray)
        case .intArray(let value):
            try container.encode(value, forKey: .intArray)
        case .doubleArray(let value):
            try container.encode(value, forKey: .doubleArray)
        }
    }
    
    var valueKey: ObservatoryValueCodingKeys {
        switch self {
        case .string:
            return .string_value
        case .int:
            return .int_value
        case .double:
            return .double_value
        case .bool:
            return .bool_value
        case .stringArray:
            return .stringArray
        case .boolArray:
            return .boolArray
        case .intArray:
            return .intArray
        case .doubleArray:
            return .doubleArray
        }
    }
}
