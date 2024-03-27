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
    let name: String
    let timeUnixNano: TimeInterval
    let attributes: [ObservatoryKeyValue]?
}
