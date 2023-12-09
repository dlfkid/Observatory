//
//  LogRecordExporter.swift
//  Pods
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

public protocol LogExportable: ProcedureEndable {
    func export(timeout: TimeInterval, batch: [LogRecordData], completion: @escaping (_ result: Result<[LogRecordData], ObservatoryError>) -> Void)
}
