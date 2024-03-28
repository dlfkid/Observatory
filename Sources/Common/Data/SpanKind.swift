//
//  SpanKind.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/25.
//

import Foundation

/// Type of span. Can be used to specify additional relationships between spans in addition to a
/// parent/child relationship
public enum SpanKind: Int, Codable {
    /// Default value. Indicates that the span is used internally.
    case unspecifued = 0
    case `internal` = 1
    /// ndicates that the span covers server-side handling of an RPC or other remote request.
    case server = 2
    /// Indicates that the span covers the client-side wrapper around an RPC or other remote request.
    case client = 3
    /// Indicates that the span describes producer sending a message to a broker. Unlike client and
    /// server, there is no direct critical path latency relationship between producer and consumer
    /// spans.
    case producer = 4
    /// Indicates that the span describes consumer receiving a message from a broker. Unlike client
    /// and server, there is no direct critical path latency relationship between producer and
    /// consumer spans.
    case consumer = 5
}
