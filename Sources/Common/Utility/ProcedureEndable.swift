//
//  ProcedureEndable.swift
//  Observatory
//
//  Created by Ravendeng on 2023/12/9.
//

import Foundation

public protocol ProcedureEndable {
    
    typealias ProcedureEndClosure = (_ ret: Bool, _ error: ObservatoryError?) -> Void
    
    /// to tell the caller wether this component is shutted down
    var isShuttedDown: Bool {get}
    
    /// shut down current componenet, call force flush before shutting down
    /// - Parameters:
    ///   - timeout: asssumed errror happend if reached timeout
    ///   - closure: result closure
    func shutdown(timeout: TimeInterval,  closure: ProcedureEndClosure?)
    
    /// foce export all the unprocessed log record
    /// - Parameters:
    ///   - timeout: asssumed errror happend if reached timeout
    ///   - closure: result closure
    func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?)
}
