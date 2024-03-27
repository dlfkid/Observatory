//
//  ReadableSpan.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public typealias ReadableAttributeCallback = (_ attributes: [ObservatoryKeyValue]) -> Void

public typealias ReadableEventCallback = (_ attributes: [Event]) -> Void

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
    
    /// acquire current attributes
    /// - Parameter complection: callback
    public func fetchAttributes(complection: @escaping ReadableAttributeCallback) {
        self.internalSpan.fetchAttributes(completion: complection)
    }
    
    /// acquire current attributes
    /// - Parameter complection: callback
    public func fetcEvents(complection: @escaping ReadableEventCallback) {
        self.internalSpan.fetchEvents(completion: complection)
    }
}
