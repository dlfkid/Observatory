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
}
