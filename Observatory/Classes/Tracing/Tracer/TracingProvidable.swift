//
//  TracingProvidable.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public protocol TracerProvidable: CachedKeyManagable {
    func createTracerIfNeeded(name: String, version: String, schemaURL: String?, attributes: [String: ObservatoryValue]?)
}
