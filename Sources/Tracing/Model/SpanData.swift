//
//  SpanData.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public struct SpanData {
    public let scope: InstrumentationScope?
    public let resource: Resource?
    public let traceID: TraceID?
    public let spanID: SpanID?
    public let parentSpanID: SpanID?
    public let trace_state: String?
    public let name: String?
    public let kind: SpanKind?
    public let startTimeUnix: TimeRepresentable?
    public let endTimeUnix: TimeRepresentable?
    public let attributes: [ObservatoryKeyValue]?
    public let dropped_attributes_count: Int?
    public let events: [Event]?
}

extension SpanData: Encodable {
    
    static func spanData(from span: Span) -> SpanData {
        SpanData(scope:span.scope, resource: span.resource, traceID: span.context.traceID, spanID: span.context.spanID, parentSpanID: span.context.parentSpanID, trace_state: nil, name: span.name, kind: span.kind, startTimeUnix: span.startTimeUnix, endTimeUnix: span.endTimeUnix, attributes: span.attributes(), dropped_attributes_count: 0, events: span.events())
    }
    
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
            case time_unix_nano = "time_unix_nano"
            case events = "events"
       }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTimeUnix?.timeUnixNano, forKey: .start_time_unix_nano)
        try container.encode(endTimeUnix?.timeUnixNano, forKey: .end_time_unix_nano)
        try container.encode(trace_state, forKey: .trace_state)
        try container.encode(traceID?.bytes, forKey: .trace_id)
        try container.encode(spanID?.bytes, forKey: .span_id)
        try container.encode(parentSpanID?.bytes, forKey: .parent_span_id)
        try container.encode(dropped_attributes_count, forKey: .dropped_attributes_count)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(name, forKey: .name)
        try container.encode(kind?.rawValue, forKey: .kind)
        try container.encode(events, forKey: .events)
    }
}
