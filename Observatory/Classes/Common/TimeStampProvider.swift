//
//  TimeStampProvider.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/14.
//

import Foundation

public protocol TimeStampProvidable {
    
    /// this method is made to return current timeStamp in millie seconds format
    /// - Returns: time stamp millie seconds
    func currentTimeStampMillieSeconds() -> TimeInterval
}

public struct TimeStampProvider: TimeStampProvidable {
    public func currentTimeStampMillieSeconds() -> TimeInterval {
        return Date().timeIntervalSince1970 * 1000
    }
}
