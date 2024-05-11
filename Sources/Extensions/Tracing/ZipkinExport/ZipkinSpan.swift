//
//  File.swift
//  
//
//  Created by Ravendeng on 2024/5/2.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif
#if canImport(ObservatoryTracing)
import ObservatoryTracing
#endif

public struct ZipkinSpanBatch: Codable {
    public let span: [ZipkinSpan]
}

public struct ZipkinSpan {
    
    public enum ZipkinSpanKind: String {
        case client = "CLIENT"
        case server = "SERVER"
        case producer = "PRODUCER"
        case consumer = "CONSUMER"
    }
    
    public struct Annotation: Codable {
        public var timestamp: TimeInterval?
        public var value: String?
        
        enum CodingKeys: String, CodingKey {
                case timestamp = "timestamp"
                case value = "value"
           }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: ZipkinSpan.Annotation.CodingKeys.self)
            try container.encodeIfPresent(Int(self.timestamp ?? 0), forKey: ZipkinSpan.Annotation.CodingKeys.timestamp)
            try container.encodeIfPresent(self.value, forKey: ZipkinSpan.Annotation.CodingKeys.value)
        }
    }
    
    public struct ZipkinEndpoint: Codable {
        public var serviceName: String?
        public var ipv4: String?
        public var ipv6: String?
        public var port: Int?
    }
    
    public static func create(from spanData: SpanData) -> ZipkinSpan {
        var zipkinSpan = ZipkinSpan()
        zipkinSpan.traceId = spanData.traceID?.hexString
        zipkinSpan.id = spanData.spanID?.hexString
        zipkinSpan.parentId = spanData.parentSpanID?.hexString
        zipkinSpan.name = spanData.name
        zipkinSpan.timestamp = spanData.startTimeUnix?.timeUnixMicro
        zipkinSpan.duration = (spanData.endTimeUnix?.timeUnixMicro ?? 0) - (spanData.startTimeUnix?.timeUnixMicro ?? 0)
        zipkinSpan.annotations = spanData.events?.map({ event in
            return Annotation(timestamp: event.timeUnix?.timeUnixMicro ?? 0, value: event.name ?? "")
        })
        var tags = [String: String]()
        spanData.attributes?.forEach({ attribute in
            let key = attribute.key
            let value = attribute.value.description
            tags[key] = value
        })
        zipkinSpan.kind = spanData.kind
        return zipkinSpan
    }
    
    public var traceId: String?
    public var id: String?
    public var parentId: String?
    public var name: String?
    public var timestamp: TimeInterval?
    public var duration: TimeInterval?
    public var annotations: [Annotation]?
    public var tags: [String: String]?
    public var kind: SpanKind?
    public var localEndpoint: ZipkinEndpoint?
    public var remoteEndpoint: ZipkinEndpoint?
    public var zipkinSpanKind: ZipkinSpanKind {
        switch kind {
        case .none:
            return .producer
        case let .some(kind: kind):
            switch kind {
            case .unspecifued:
                return .producer
            case .internal:
                return .producer
            case .server:
                return .server
            case .client:
                return .client
            case .producer:
                return .producer
            case .consumer:
                return .consumer
            }
        }
    }
}

extension ZipkinSpan: Codable {
    enum CodingKeys: String, CodingKey {
            case traceId = "traceId"
            case id = "id"
            case parentId = "parentId"
            case name = "name"
            case timestamp = "timestamp"
            case duration = "duration"
            case annotations = "annotations"
            case kind = "kind"
            case remoteEndpoint = "remoteEndpoint"
            case localEndpoint = "localEndpoint"
       }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int(timestamp ?? 0), forKey: CodingKeys.timestamp)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(traceId, forKey: CodingKeys.traceId)
        try container.encode(parentId, forKey: CodingKeys.parentId)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(Int(duration ?? 0), forKey: CodingKeys.duration)
        try container.encode(annotations, forKey: CodingKeys.annotations)
        try container.encode(zipkinSpanKind.rawValue, forKey: CodingKeys.kind)
        try container.encode(remoteEndpoint, forKey: .remoteEndpoint)
        try container.encode(localEndpoint, forKey: .localEndpoint)
    }
}


