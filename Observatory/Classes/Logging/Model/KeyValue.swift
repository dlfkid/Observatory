//
//  KeyValue.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/7.
//

import Foundation

public enum ObservableValue {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case stringArray([String])
    case boolArray([Bool])
    case intArray([Int])
    case doubleArray([Double])
}

extension ObservableValue {
    var valueKey: String {
        switch self {
        case .string:
            return "string_value"
        case .int:
            return "int_value"
        case .double:
            return "double_value"
        case .bool:
            return "bool_value"
        case .stringArray:
            return "stringArray"
        case .boolArray:
            return "boolArray"
        case .intArray:
            return "intArray"
        case .doubleArray:
            return "doubleArray"
        }
    }
    
    var metaData: [String: Any] {
        switch self {
        case .string(let value):
            return [self.valueKey: value]
        case .int(let value):
            return [self.valueKey: value]
        case .double(let value):
            return [self.valueKey: value]
        case .bool(let value):
            return [self.valueKey: value]
        case .stringArray(let value):
            return [self.valueKey: value]
        case .boolArray(let value):
            return [self.valueKey: value]
        case .intArray(let value):
            return [self.valueKey: value]
        case .doubleArray(let value):
            return [self.valueKey: value]
        }
    }
}
