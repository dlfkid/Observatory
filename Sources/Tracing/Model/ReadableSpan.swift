//
//  ReadableSpan.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public struct ReadableSpan {
    
    private let internalSpan: Span
    
    init(internalSpan: Span) {
        self.internalSpan = internalSpan
    }
    
    public func end(endTimeUnixNano: TimeInterval? = nil) {
        self.internalSpan.end(endTimeUnixNano: endTimeUnixNano)
    }
    
    public func addEvent(name: String, attributes: [ObservatoryKeyValue]?, timeUnixNano: TimeInterval? = nil) {
        self.internalSpan.addEvent(name: name, attributes: attributes, timeUnixNano: timeUnixNano)
    }
}
