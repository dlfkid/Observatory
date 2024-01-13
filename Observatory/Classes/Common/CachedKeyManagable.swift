//
//  CachedKeyManagable.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/13.
//

import Foundation

public protocol CachedKeyManagable {
    func createInstrumentScopeCachedKey(name: String, version: String, schemaURL: String?) -> String
}

extension CachedKeyManagable {
    public func createInstrumentScopeCachedKey(name: String, version: String, schemaURL: String?) -> String {
        return String("\(name)_\(version)_\(schemaURL ?? "")")
    }
}
