//
//  LogRecordData.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public enum LogRecordFlags: UInt {
  case unspecified = 0;
  case mask = 0x000000FF;
}

public struct LogRecordData {
    let timeUnix: TimeRepresentable?
    let body: String?
    let traceID: TraceID?
    let spanID: SpanID?
    let severity_text: String?
    let severity_number: Int?
    let dropped_attributes_count: Int?
    let attributes: [ObservatoryKeyValue]?
    let flags: LogRecordFlags
    let scope: InstrumentationScope?
    let resource: Resource?
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
        try container.encode(timeUnix?.timeUnixNano, forKey: .time_unix_nano)
        try container.encode(body, forKey: .body)
        try container.encode(traceID?.bytes, forKey: .trace_id)
        try container.encode(spanID?.bytes, forKey: .span_id)
        try container.encode(severity_text, forKey: .severity_text)
        try container.encode(severity_number, forKey: .severity_number)
        try container.encode(dropped_attributes_count, forKey: .dropped_attributes_count)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(flags.rawValue, forKey: .flags)
    }
}
