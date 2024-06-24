//
//  ZipkinStorage.swift
//  
//
//  Created by Ravendeng on 2024/5/10.
//

import UIKit
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif
#if canImport(ObservatoryTracing)
import ObservatoryTracing
#endif

public class ZipkinSpanStorage: TelemetryExportable {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let serviceName: String
    
    private let searchPath: FileManager.SearchPathDirectory
    
    private let subdir: String
    
    var shuttedDown = false
    
    public init(serviceName: String = "observatory_exporter_zipkin", searchPath: FileManager.SearchPathDirectory, subdir: String) {
        self.serviceName = serviceName
        self.subdir = subdir
        self.searchPath = searchPath
    }
    
    public typealias TelemetryData = SpanData
    
    public func export<TelemetryData>(resource: Resource?, scope: InstrumentationScope?, timeout: TimeInterval, batch: [TelemetryData], completion: @escaping (Result<[TelemetryData], ObservatoryError>) -> Void) where TelemetryData : Encodable {
        let spanDatas = batch as! [SpanData]
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: Make the JSON output more readable
        for spanData in spanDatas {
            var zipkinSpan = ZipkinSpan.create(from: spanData)
            zipkinSpan.localEndpoint = ZipkinSpan.ZipkinEndpoint(serviceName: serviceName)
            do {
                let jsonData = try encoder.encode(zipkinSpan)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("[Span Exported]: \(jsonString)")
                }
                let dateString = dateFormatter.string(from: Date())
                SandBoxDataWriter.saveDataToSandBox(searchPath: searchPath, subDir: String("/\(subdir)/\(serviceName)"), fileName: String("/\(dateString).json"), jsonData) { error in
                    if let error = error {
                        completion(.failure(.dataError(msg: "[Span Exported]: Error saving data to sandbox: \(error)")))
                    } else {
                        completion(.success(batch))
                    }
                }
            } catch {
                completion(.failure(.dataError(msg: "[Span Exported]: Error encoding JSON: \(error)")))
            }
        }
    }
}

extension ZipkinSpanStorage: ProcedureEndable {
    public var isShuttedDown: Bool {
        return shuttedDown
    }
    
    public func shutdown(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        defer {
            shuttedDown = true
        }
        if isShuttedDown {
            guard let closure = closure else {
                return
            }
            closure(false, .alreadyShuttedDown(component: "ZipkinSpanExporter"))
            return
        }
        forceFlush(timeout: timeout, closure: closure)
    }
    
    public func forceFlush(timeout: TimeInterval, closure: ProcedureEndClosure?) {
        guard let closure = closure else {
            return
        }
        closure(true, nil)
    }
}
