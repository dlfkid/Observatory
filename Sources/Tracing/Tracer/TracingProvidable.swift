//
//  TracingProvidable.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

public protocol TracerProvidable: CachedKeyManagable {
    
    var timeStampProvider: TimeStampProvidable {get}
    
    func createTracerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String: ObservatoryValue]?) -> Tracerable
    
    func onSpanStarted(span: Span)
    
    func onSpanEnded(span: Span)
}
