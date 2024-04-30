//
//  TimeStampProvider.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/14.
//

import Foundation

public protocol TimeStampProvidable {
    associatedtype TimeObject: TimeRepresentable
    /// this method is made to return current time
    /// - Returns: time stamp millie seconds
    func currentTime() -> TimeObject
}

public struct TimeStampProvider: TimeStampProvidable {
    
    public typealias TimeObject = Date
    
    public func currentTime() -> Date {
        let date = Date()
        return date
    }
    
    public init() {}
}

extension NSDate: TimeRepresentable {
    public var timeUnixNano: TimeInterval {
        return self.timeIntervalSince1970 * 1_000_000_000
    }
    
    public var timeUnixMillie: TimeInterval {
        return self.timeIntervalSince1970 * 1_000
    }
    
    public var timeUnixMicro: TimeInterval {
        return self.timeIntervalSince1970 * 1_000_000
    }
}

extension Date: TimeRepresentable {
    public var timeUnixNano: TimeInterval {
        return self.timeIntervalSince1970 * 1_000_000_000
    }
    
    public var timeUnixMillie: TimeInterval {
        return self.timeIntervalSince1970 * 1_000
    }
    
    public var timeUnixMicro: TimeInterval {
        return self.timeIntervalSince1970 * 1_000_000
    }
}
