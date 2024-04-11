//
//  SpanDataProcessor.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public protocol SpanProcessable: ProcedureEndable {
    
    associatedtype Exporter: TelemetryExportable
    
    var exporter: Exporter? {get}
    
    func onSpanStarted(span: Span)
    
    func onSpanEnded(span: Span)
}
