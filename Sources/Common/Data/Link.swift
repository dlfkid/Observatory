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
    
    let trace_state: String?
    
    let dropped_attributes_count: Int?
    
    let trace_id: Data?
    
    let span_id: Data?
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
        try container.encode(dropped_attributes_count, forKey: .dropped_attributes_count)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(trace_state, forKey: .trace_state)
        try container.encode(trace_id, forKey: .trace_id)
        try container.encode(span_id, forKey: .span_id)
    }
}
