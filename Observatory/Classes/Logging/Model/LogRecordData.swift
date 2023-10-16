//
//  LogRecordData.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

enum LogRecordFlags: UInt {
  case unspecified = 0;
  case mask = 0x000000FF;
}

public struct LogRecordData {
    let time_unix_nano: TimeInterval
    let body: Data?
    let trace_id: Data?
    let span_id: Data?
    let severity_text: String?
    let severity_number: Int?
    let dropped_attributes_count: Int?
    let attributes: [String : ObservableValue]?
    let flags: LogRecordFlags
}

extension LogRecordData: Encodable {
    enum CodingKeys: String, CodingKey {
            case time_unix_nano = "time_unix_nano"
            case body = "body"
            case trace_id = "trace_id"
            case span_id = "span_id"
            case severity_text = "severity_text"
            case severity_number = "severity_number"
            case dropped_attributes_count = "dropped_attributes_count"
            case attributes = "attributes"
            case flags = "flags"
       }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time_unix_nano, forKey: .time_unix_nano)
        try container.encode(body, forKey: .body)
        try container.encode(trace_id, forKey: .trace_id)
        try container.encode(span_id, forKey: .span_id)
        try container.encode(severity_text, forKey: .severity_text)
        try container.encode(severity_number, forKey: .severity_number)
        try container.encode(dropped_attributes_count, forKey: .dropped_attributes_count)
        if let attributes = attributes {
            var encodedAttributes = [String: Data]()
            attributes.forEach { (key: String, observableValue: ObservableValue) in
                switch observableValue {
                case .string(let value):
                    encodedAttributes[key] = value.data(using: .utf8)
                case .int(let value):
                    var value = value
                    encodedAttributes[key] = Data(bytes: &value, count: MemoryLayout<Int>.size)
                case .double(let value):
                    var value = value
                    encodedAttributes[key] = Data(bytes: &value, count: MemoryLayout<Double>.size)
                case .bool(let value):
                    var value = value
                    encodedAttributes[key] = Data(bytes: &value, count: MemoryLayout<Bool>.size)
                case .doubleArray:
                    break
                case .stringArray:
                    break
                case .boolArray:
                    break
                case .intArray:
                    break
                }
            }
            try container.encode(encodedAttributes, forKey: .attributes)
        
        }
        try container.encode(flags.rawValue, forKey: .flags)
    }
}
