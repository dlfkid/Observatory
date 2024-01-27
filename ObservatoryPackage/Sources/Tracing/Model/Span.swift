//
//  Span.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
import ObservatoryCommon

public class Span {
    let name: String
    let kind: SpanKind
    
    private var internalAttributes = [ObservatoryKeyValue]()
    
    var attributes: [ObservatoryKeyValue]? {
        guard internalAttributes.count > 0 else {
            return nil
        }
        return internalAttributes
    }
    
    internal init(name: String, kind: SpanKind) {
        self.name = name
        self.kind = kind
    }
    
    convenience init(name: String, kind: SpanKind, attributes: [ObservatoryKeyValue]?) {
        self.init(name: name, kind: kind)
        if let attributes = attributes {
            self.internalAttributes.append(contentsOf: attributes)
        }
    }
}
