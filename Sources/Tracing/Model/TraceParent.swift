//
//  File.swift
//  
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2024/6/19.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

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

public extension String {
    func obs_traceParent() -> TraceParent? {
        return NSString(string: self).obs.traceParent()
    }
}

extension NSString: ObservatoryWrapperable {}

public extension ObservatoryWrapper where T: NSString {
    func traceParent() -> TraceParent? {
        let string = String(value)
        let traceParentKeyValus = string.components(separatedBy: "-")
        guard traceParentKeyValus.count == 4 else {
            return nil
        }
        let version = traceParentKeyValus[0]
        let traceId = traceParentKeyValus[1]
        let spanId = traceParentKeyValus[2]
        let sampled = traceParentKeyValus[3]
        let parent = TraceParent(version: version, traceIdHex: traceId, spanIdHex: spanId, sampled: sampled)
        return parent
    }
}
