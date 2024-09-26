//
//  File.swift
//  
//
//  Created by LeonDeng on 2024/1/23.
//

import Foundation

public struct Link {
    
    public let context: Context
    
    public let attributes: [ObservatoryKeyValue]?
    
    public let traceState: TraceState?
    
    public let droppedAttributesCount: Int?
    
    public var traceID: TraceID? {
        return context.traceID
    }
    
    public var spanID: SpanID? {
        return context.spanID
    }
    
    public init(context: Context, attributes: [ObservatoryKeyValue]?, traceState: TraceState?, droppedAttributesCount: Int?) {
        self.context = context
        self.attributes = attributes
        self.traceState = traceState
        self.droppedAttributesCount = droppedAttributesCount
    }
}

extension Link: Encodable {
    enum CodingKeys: String, CodingKey {
        case dropped_attributes_count = "dropped_attributes_count"
        case attributes = "attributes"
        case trace_state = "trace_state"
        case trace_id = "trace_id"
        case span_id = "span_id"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(droppedAttributesCount, forKey: .dropped_attributes_count)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(traceState?.w3cTraceStateHeader, forKey: .trace_state)
        try container.encode(traceID?.bytes, forKey: .trace_id)
        try container.encode(spanID?.bytes, forKey: .span_id)
    }
}
