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
    /*
     string string_value = 1;
     bool bool_value = 2;
     int64 int_value = 3;
     double double_value = 4;
     ArrayValue array_value = 5;
     KeyValueList kvlist_value = 6;
     bytes bytes_value = 7;
     */
    
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
}
