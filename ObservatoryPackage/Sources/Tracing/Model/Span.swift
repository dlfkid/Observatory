//
//  Span.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
import ObservatoryCommon

public struct SpanLimit {
    let maxAttributesCount: Int
    let maxLinkCount: Int
    let maxEventCount: Int
    let attributeLimit: LimitConfig
}

public class Span {
    let name: String
    let kind: SpanKind
    let limit: SpanLimit
    let context: SpanContext
    let scope: InstrumentationScope
    var startTimeUnixNano: TimeInterval = 0
    var endTimeUnixNano: TimeInterval = 0
    var ended: Bool = false
    
    private var operateQueue: DispatchQueue?
    
    private weak var provider: (AnyObject & TracerProvidable)?
    
    private var internalAttributes = [ObservatoryKeyValue]()
    
    internal init(name: String, kind: SpanKind, limit: SpanLimit, context: SpanContext, scope: InstrumentationScope, provider: (AnyObject & TracerProvidable)?, queue: DispatchQueue?) {
        self.name = name
        self.kind = kind
        self.limit = limit
        self.context = context
        self.provider = provider
        self.scope = scope
        self.operateQueue = queue
    }
    
    internal convenience init(name: String, kind: SpanKind, limit: SpanLimit, context: SpanContext, attributes: [ObservatoryKeyValue]?, scope: InstrumentationScope, provider: (AnyObject & TracerProvidable)?, queue: DispatchQueue?) {
        self.init(name: name, kind: kind, limit: limit, context: context, scope: scope, provider: provider, queue: queue)
        if let attributes = attributes {
            self.internalAttributes.append(contentsOf: attributes)
        }
    }
    
    func end(endTimeUnixNano: TimeInterval = 0) {
        operateQueue?.async {
            if self.ended {
                return
            }
            self.ended = true
            self.endTimeUnixNano = endTimeUnixNano
            self.provider?.onSpanEnded(span: self)
        }
    }
}
