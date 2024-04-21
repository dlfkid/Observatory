//
//  ObservatoryError.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/23.
//

import Foundation

public enum ObservatoryError: Error {
    case timout(component: String? = nil)
    case alreadyShuttedDown(component: String? = nil)
    case normal(msg: String)
}

extension ObservatoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .timout(component: component):
            if let component = component {
                return String("Timeout, \(component) is not responding")
            }
            return "Timeout"
        case let .alreadyShuttedDown(component: component):
            if let component = component {
                return String("Already shutted down, \(component)")
            }
            return "Already shutted down"
        case let .normal(msg: msg):
            return msg
        }
    }
}
