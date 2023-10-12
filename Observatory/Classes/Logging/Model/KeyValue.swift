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
    case float(Float)
    case double(Double)
    case bool(Bool)
    case array([ObservableValue])
    case keyValueList([String: ObservableValue])
}
