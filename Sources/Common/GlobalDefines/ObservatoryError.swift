//
//  ObservatoryError.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/23.
//

import Foundation

public enum ObservatoryError: Error {
    case timout(component: String?)
    case alreadyShuttedDown(component: String?)
    case normal(msg: String?)
    case network(msg: String?)
    case dataError(msg: String?)
    case fileManage(msg: String?)
    case export(msg: String?)
    case limitReached(msg: String?)
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
        case .network(msg: let msg):
            return msg
        case .dataError(msg: let msg):
            return msg
        case .fileManage(msg: let msg):
            return msg
        case .export(msg: let msg):
            return msg
        case .limitReached(msg: let msg):
            return String("Reached the limitation of the configuration \(msg)")
        }
    }
}
