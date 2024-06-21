//
//  TracingExtension.swift
//
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2024/6/21.
//

import UIKit
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

extension UIViewController: ObservatoryWrapperable {}

public extension ObservatoryWrapper where T: UIViewController {
    func spanStart(name: String, kind: SpanKind = .producer, parentContext: SpanContext? = nil, attributes: [ObservatoryKeyValue]? = nil, startTimeUnixNano: TimeRepresentable? = nil, linkes:[Link]? = nil, traceStateStr: String? = nil) -> ReadableSpan? {
        return TracerProvider.latestTracer?.createSpan(name: name, kind: kind, superSpanContext: parentContext, attributes: attributes, startTimeUnixNano: startTimeUnixNano, linkes: linkes, traceState: TraceState(raw: traceStateStr))
    }
}
