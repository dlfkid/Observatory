//
//  LogRecordData.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public struct InstrumentationScope: Hashable, Equatable {
  // An empty instrumentation scope name means the name is unknown.
    let name: String
    let version: String
}

public enum LogRecordFlags: UInt {
  case unspecified = 0;
  case mask = 0x000000FF;
}

public struct LogRecordData {
    let time_unix_nano: TimeInterval
    let body: String?
    let trace_id: Data?
    let span_id: Data?
    let severity_text: String?
    let severity_number: Int?
    let dropped_attributes_count: Int?
    let attributes: [ObservatoryKeyValue]?
    let flags: LogRecordFlags
    let scope: InstrumentationScope
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
        try container.encode(attributes, forKey: .attributes)
        try container.encode(flags.rawValue, forKey: .flags)
    }
}
