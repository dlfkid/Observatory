//
//  Event.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public struct Event {
    let name: String
    let timeUnixNano: TimeInterval
    let attributes: [ObservatoryKeyValue]?
}
