//
//  SpanData.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public struct SpanData {
    let trace_id: Data?
    let span_id: Data?
    let parent_span_id: Data?
    let trace_state: String?
    let name: String?
    let kind: SpanKind?
    let start_time_unix_nano: TimeInterval?
    let end_time_unix_nano: TimeInterval?
    let attributes: [ObservatoryKeyValue]?
    let dropped_attributes_count: Int?
}

extension SpanData: Encodable {
    enum CodingKeys: String, CodingKey {
            case start_time_unix_nano = "start_time_unix_nano"
            case end_time_unix_nano = "end_time_unix_nano"
            case parent_span_id = "parent_span_id"
            case trace_id = "trace_id"
            case span_id = "span_id"
            case trace_state = "trace_state"
            case dropped_attributes_count = "dropped_attributes_count"
            case attributes = "attributes"
            case name = "name"
            case kind = "kind"
            case time_unix_nano
       }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start_time_unix_nano, forKey: .start_time_unix_nano)
        try container.encode(end_time_unix_nano, forKey: .end_time_unix_nano)
        try container.encode(trace_state, forKey: .trace_state)
        try container.encode(trace_id, forKey: .trace_id)
        try container.encode(span_id, forKey: .span_id)
        try container.encode(parent_span_id, forKey: .parent_span_id)
        try container.encode(dropped_attributes_count, forKey: .dropped_attributes_count)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(name, forKey: .name)
        try container.encode(kind?.rawValue, forKey: .kind)
    }
}
