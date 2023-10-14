//
//  LogRecord.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public enum LogRecord {
    case trace(body: String, timeStamp: TimeInterval = 0, attributes: [String : ObservableValue]? = nil, traceID: Data? = nil, spanID: Data? = nil)
    case debug(body: String, timeStamp: TimeInterval = 0, attributes: [String : ObservableValue]? = nil, traceID: Data? = nil, spanID: Data? = nil)
    case info(body: String, timeStamp: TimeInterval = 0, attributes: [String : ObservableValue]? = nil, traceID: Data? = nil, spanID: Data? = nil)
    case warn(body: String, timeStamp: TimeInterval = 0, attributes: [String : ObservableValue]? = nil, traceID: Data? = nil, spanID: Data? = nil)
    case error(body: String, timeStamp: TimeInterval = 0, attributes: [String : ObservableValue]? = nil, traceID: Data? = nil, spanID: Data? = nil)
    case fatal(body: String, timeStamp: TimeInterval = 0, attributes: [String : ObservableValue]? = nil, traceID: Data? = nil, spanID: Data? = nil)
}

public extension LogRecord {
    var severityNumber: Int {
        switch self  {
        case .trace:
            return 4
        case .debug:
            return 8
        case .info:
            return 12
        case .warn:
            return 16
        case .error:
            return 20
        case .fatal:
            return 24
        }
    }
    
    var severityName: String {
        switch self {
        case .trace:
            return "TRACE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warn:
            return "WARN"
        case .error:
            return "ERROR"
        case .fatal:
            return "FATAL"
        }
    }
}
