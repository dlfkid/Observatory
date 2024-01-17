//
//  Exportable.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/14.
//

import Foundation

public protocol TelemetryExportable: ProcedureEndable {
    associatedtype TelemetryData
    func export<TelemetryData: Encodable>(timeout: TimeInterval, batch: [TelemetryData], completion: @escaping (_ result: Result<[TelemetryData], ObservatoryError>) -> Void)
}
