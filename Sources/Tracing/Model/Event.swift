//
//  Event.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public struct Event {
    let name: String?
    let timeUnix: TimeRepresentable?
    let attributes: [ObservatoryKeyValue]?
}

extension Event: Encodable {
    enum CodingKeys: String, CodingKey {
        case time_unix_nano = "time_unix_nano"
        case dropped_attributes_count = "dropped_attributes_count"
        case attributes = "attributes"
        case name = "name"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(timeUnix?.timeUnixNano, forKey: .time_unix_nano)
    }
}
