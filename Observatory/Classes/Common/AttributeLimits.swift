//
//  AttributeLimits.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/28.
//

import Foundation

struct LimitConfig {
    var maximumNumberOfAttributes: Int? = 128
    var maximumLengthForValue: Int? = 1024
    var invalidKeys: [String]?
}
