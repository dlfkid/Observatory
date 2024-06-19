//
//  File.swift
//  
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2024/6/19.
//

import Foundation

public struct TraceParent {
    public var version: String?
    public var traceIdHex: String?
    public var spanIdHex: String?
    public var sampled: String?
}

public extension TraceParent {
    public var isSampled: Bool {
        return sampled == "01"
    }
}
