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

extension NSObject: ObservatoryWrapperable {}

public extension ObservatoryWrapper where T: UIViewController {
    
    /// Fast span creatation method
    /// - Parameters:
    ///   - tracerInfo: Info that required to identify a created tracer
    ///   - name: span name
    ///   - kind: span kind
    ///   - parentContext: super span's context
    ///   - attributes: attributes
    ///   - startTimeUnixNano: start time
    ///   - linkes: links
    ///   - traceStateStr: trace state
    /// - Returns: A redable span
    func spanStart(tracerInfo: (name: String, version: String, schemaURL: String?)? = nil, name: String, kind: SpanKind = .producer, parentContext: SpanContext? = nil, attributes: [ObservatoryKeyValue]? = nil, startTimeUnixNano: TimeRepresentable? = nil, linkes:[Link]? = nil, traceStateStr: String? = nil) -> ReadableSpan? {
        guard let tracerInfo = tracerInfo else {
            return TracerProvider.latestTracer?.createSpan(name: name, kind: kind, superSpanContext: parentContext, attributes: attributes, startTimeUnixNano: startTimeUnixNano, linkes: linkes, traceState: TraceState(raw: traceStateStr))
        }
        let tracer = TracerProvider.lastTracerProvider?.createTracerIfNeeded(name: tracerInfo.name, version: tracerInfo.version, schemaURL: tracerInfo.schemaURL, attributes: nil)
        return tracer?.createSpan(name: name, kind: kind, superSpanContext: parentContext, attributes: attributes, startTimeUnixNano: startTimeUnixNano, linkes: linkes, traceState: TraceState(raw: traceStateStr))
    }
}
