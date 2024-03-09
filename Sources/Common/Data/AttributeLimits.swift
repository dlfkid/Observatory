//
//  AttributeLimits.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/28.
//

import Foundation

public struct LimitConfig {
    public var maximumNumberOfAttributes: Int? = 128
    public var maximumLengthForValue: Int? = 1024
    public var invalidKeys: [String]?
    
    public init(maximumNumberOfAttributes: Int? = nil, maximumLengthForValue: Int? = nil, invalidKeys: [String]? = nil) {
        self.maximumNumberOfAttributes = maximumNumberOfAttributes
        self.maximumLengthForValue = maximumLengthForValue
        self.invalidKeys = invalidKeys
    }
}
