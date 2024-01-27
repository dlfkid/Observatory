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
    
    private var internalAttributes = [ObservatoryKeyValue]()
    
    var attributes: [ObservatoryKeyValue]? {
        guard internalAttributes.count > 0 else {
            return nil
        }
        return internalAttributes
    }
    
    internal init(name: String, kind: SpanKind, limit: SpanLimit, context: SpanContext) {
        self.name = name
        self.kind = kind
        self.limit = limit
        self.context = context
    }
    
    convenience init(name: String, kind: SpanKind, limit: SpanLimit, context: SpanContext, attributes: [ObservatoryKeyValue]?) {
        self.init(name: name, kind: kind, limit: limit, context: context)
        if let attributes = attributes {
            self.internalAttributes.append(contentsOf: attributes)
        }
    }
    
    
    
}
