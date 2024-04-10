//
//  Span.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif

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
    
    private var internalEvents = [Event]()
    
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
    
    func end(endTimeUnixNano: TimeInterval? = nil) {
        operateQueue?.async {
            if self.ended {
                return
            }
            self.ended = true
            let timeStamp = endTimeUnixNano ?? self.provider?.timeStampProvider.currentTimeStampMillieSeconds() ?? 0
            self.endTimeUnixNano = timeStamp
            self.provider?.onSpanEnded(span: self)
        }
    }
    
    func addEvent(name: String, attributes: [ObservatoryKeyValue]?, timeUnixNano: TimeInterval? = nil) {
        operateQueue?.async {
            if self.ended {
                return
            }
            let timeStamp = timeUnixNano ?? self.provider?.timeStampProvider.currentTimeStampMillieSeconds() ?? 0
            let event = Event(name: name, time_unix_nano: timeStamp, attributes: attributes)
            self.internalEvents.append(event)
        }
    }
    
    func fetchAttributes(completion: @escaping ReadableAttributeCallback) {
        operateQueue?.async {
            let attributes = self.internalAttributes
            DispatchQueue.main.async {
                completion(attributes)
            }
        }
    }
    
    func fetchEvents(completion: @escaping ReadableEventCallback) {
        operateQueue?.async {
            let events = self.internalEvents
            DispatchQueue.main.async {
                completion(events)
            }
        }
    }
    
    func events() -> [Event]? {
        var events: [Event]? = nil
        operateQueue?.sync {
            events = self.internalEvents
        }
        return events
    }
    
    func attributes() -> [ObservatoryKeyValue]? {
        var attributes: [ObservatoryKeyValue]? = nil
        operateQueue?.sync {
            attributes = self.internalAttributes
        }
        return attributes
    }
}
