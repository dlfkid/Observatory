//
//  SpanDataProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public protocol SpanProcessable: ProcedureEndable {
    var exporter: (any TelemetryExportable)? {get}
    
    func onSpanStarted(span: ReadableSpan)
    
    func onSpanEnded(span: ReadableSpan)
}
