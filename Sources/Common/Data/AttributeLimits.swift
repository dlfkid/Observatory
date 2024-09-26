//
//  AttributeLimits.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/28.
//

import Foundation

public struct AttributeLimit {
    public var maximumAttriForSpan: Int
    public var maximumAttriForLink: Int
    public var maximumAttriForEvent: Int
    public var invalidKeys: [String]?
    
    public init(maximumAttriForSpan: Int, maximumAttriForLink: Int, maximumAttriForEvent: Int, invalidKeys: [String]? = nil) {
        self.maximumAttriForSpan = maximumAttriForSpan
        self.maximumAttriForLink = maximumAttriForLink
        self.maximumAttriForEvent = maximumAttriForEvent
        self.invalidKeys = invalidKeys
    }
}
