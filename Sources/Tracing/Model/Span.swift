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
    let maxLinkCount: Int
    let maxEventCount: Int
    let attributeLimit: AttributeLimit
}

public class Span {
    var resource: Resource?
    let name: String
    let kind: SpanKind
    let limit: SpanLimit
    let context: SpanContext
    let scope: InstrumentationScope
    var startTimeUnix: TimeRepresentable?
    var endTimeUnix: TimeRepresentable?
    var ended: Bool = false
    
    private var operateQueue: DispatchQueue?
    
    fileprivate weak var provider: (AnyObject & TracerProvidable)?
    
    fileprivate weak var tracer: (AnyObject & Tracerable)?
    
    private var internalAttributes = [ObservatoryKeyValue]()
    
    private var internalEvents = [Event]()
    
    private var internalLinks = [Link]()
    
    internal init(resource: Resource?, name: String, kind: SpanKind, limit: SpanLimit, context: SpanContext, scope: InstrumentationScope, provider: (AnyObject & TracerProvidable)?, tracer: (AnyObject & Tracerable)?, queue: DispatchQueue?) {
        self.name = name
        self.kind = kind
        self.limit = limit
        self.context = context
        self.provider = provider
        self.scope = scope
        self.operateQueue = queue
        self.resource = resource
    }
    
    internal convenience init(name: String, kind: SpanKind, limit: SpanLimit, context: SpanContext, attributes: [ObservatoryKeyValue]?, scope: InstrumentationScope, provider: (AnyObject & TracerProvidable)?, tracer: (AnyObject & Tracerable)?, queue: DispatchQueue?) {
        self.init(resource: nil, name: name, kind: kind, limit: limit, context: context, scope: scope, provider: provider, tracer: tracer, queue: queue)
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
            self.endTimeUnix = self.provider?.timeStampProvider.currentTime()
            self.provider?.onSpanEnded(span: self)
        }
    }
    
    func addEvent(name: String, attributes: [ObservatoryKeyValue]?, timeUnixNano: TimeInterval? = nil) {
        operateQueue?.async {
            guard self.internalEvents.count <= self.limit.maxEventCount else {
                return
            }
            if self.ended {
                return
            }
            let event = Event(name: name, timeUnix: self.provider?.timeStampProvider.currentTime(), attributes: attributes)
            self.internalEvents.append(event)
        }
    }
    
    /*
     public let context: Context
     
     public let attributes: [ObservatoryKeyValue]?
     
     public let traceState: TraceState?
     
     public let droppedAttributesCount: Int?
     */
    
    func addLink(context: Context, attributes: [ObservatoryKeyValue]?, state: TraceState?) {
        operateQueue?.async {
            guard self.internalLinks.count <= self.limit.maxLinkCount else {
                return
            }
            var actualAttributes: [ObservatoryKeyValue]? = nil
            var droppedCount = 0
            if let attributes = attributes {
                var tempAttributes = [ObservatoryKeyValue]()
                for (index, value) in attributes.enumerated() {
                    guard index < self.limit.attributeLimit.maximumAttriForLink else {
                        droppedCount += 1
                        continue
                    }
                    tempAttributes.append(value)
                }
                actualAttributes = tempAttributes
            }
            let link = Link(context: context, attributes: actualAttributes, traceState: state, droppedAttributesCount: droppedCount)
            self.internalLinks.append(link)
        }
    }
    
    func events() -> [Event]? {
        var events: [Event]? = nil
        operateQueue?.sync {
            events?.append(contentsOf: self.internalEvents)
        }
        return events
    }
    
    func attributes() -> [ObservatoryKeyValue]? {
        var attributes: [ObservatoryKeyValue]? = nil
        operateQueue?.sync {
            attributes?.append(contentsOf: self.internalAttributes)
        }
        return attributes
    }
    
    func links() -> [Link]? {
        var links: [Link]? = nil
        operateQueue?.sync {
            links?.append(contentsOf: self.internalLinks)
        }
        return links
    }
}

extension Span {
    func readableSpan() -> ReadableSpan {
        return ReadableSpan(internalSpan: self)
    }
}

public typealias ReadableAttributeCallback = (_ attributes: [ObservatoryKeyValue]) -> Void

public typealias ReadableEventCallback = (_ attributes: [Event]) -> Void

public struct ReadableSpan {
    
    public let events: [Event]?
    
    public let attributes: [ObservatoryKeyValue]?
    
    public let links: [Link]?
    
    public var context: SpanContext {
        return internalSpan.context
    }
    
    fileprivate let internalSpan: Span
    
    init(internalSpan: Span) {
        self.internalSpan = internalSpan
        self.events = internalSpan.events()
        self.attributes = internalSpan.attributes()
        self.links = internalSpan.links()
    }
    
    public func end(endTimeUnixNano: TimeInterval? = nil) {
        self.internalSpan.end(endTimeUnixNano: endTimeUnixNano)
    }
    
    public func addEvent(name: String, attributes: [ObservatoryKeyValue]? = nil, timeUnixNano: TimeInterval? = nil) {
        self.internalSpan.addEvent(name: name, attributes: attributes, timeUnixNano: timeUnixNano)
    }
    
    public func addLink(context: Context, attributes: [ObservatoryKeyValue]? = nil, state: TraceState? = nil) {
        self.internalSpan.addLink(context: context, attributes: attributes, state: state)
    }
    
    /// Create a subspan of current span
    /// - Parameters:
    ///   - name: subspan name
    ///   - kind: kind
    ///   - attributes: attributes description
    ///   - startTimeUnixNano: startTimeUnixNano description
    ///   - linkes: linkes description
    ///   - traceStateStr: traceStateStr description
    /// - Returns: description
    func addSubspan(name: String, kind: SpanKind = .producer, attributes: [ObservatoryKeyValue]? = nil, startTimeUnixNano: TimeRepresentable? = nil, linkes:[Link]? = nil, traceStateStr: String? = nil) -> ReadableSpan? {
        let internalSpan = internalSpan
        guard let tracer = internalSpan.tracer else {
            return nil
        }
        return tracer.createSpan(name: name, kind: kind, superSpanContext: internalSpan.context, attributes: nil, startTimeUnixNano: startTimeUnixNano, linkes: linkes, traceState: TraceState(raw: traceStateStr))
    }
    
    /// Link this span to another span
    /// - Parameters:
    ///   - span: span description
    ///   - attributes: attributes description
    ///   - state: state description
    func linkToSpan(_ span: ReadableSpan, attributes: [ObservatoryKeyValue]? = nil, state: TraceState? = nil) {
        let internalSpan = internalSpan
        internalSpan.addLink(context: span.context, attributes: attributes, state: state)
    }
}
