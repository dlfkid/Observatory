//
//  LogSeverity.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public enum LogSeverity {
    case trace
    case debug
    case info
    case warn
    case error
    case fatal
}

public extension LogSeverity {
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
