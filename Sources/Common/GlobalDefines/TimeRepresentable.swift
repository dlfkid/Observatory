//
//  File.swift
//  
//
//  Created by Ravendeng on 2024/4/30.
//

import Foundation

public protocol TimeRepresentable {
    /// return time stamp with precision nano second
    var timeUnixNano: TimeInterval {get}
    /// return time stamp with precision millie second
    var timeUnixMillie: TimeInterval {get}
    /// return time stamp with precision micro second
    var timeUnixMicro: TimeInterval {get}
}
