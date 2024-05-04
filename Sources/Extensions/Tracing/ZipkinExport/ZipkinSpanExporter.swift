//
//  File.swift
//  
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2024/5/2.
//

import Foundation
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif
#if canImport(ObservatoryTracing)
import ObservatoryTracing
#endif

public class ZipkinTraceExporter {
    
    private let api = "/api/v2/spans"
    
    private let endPoint: String
    
    var shuttedDown = false
    
    public init(endPoint: String) {
        self.endPoint = endPoint
    }
}

extension ZipkinTraceExporter: TelemetryExportable {
    public typealias TelemetryData = SpanData
    
    public func export<TelemetryData>(resource: Resource?, scope: InstrumentationScope?, timeout: TimeInterval, batch: [TelemetryData], completion: @escaping (Result<[TelemetryData], ObservatoryError>) -> Void) where TelemetryData : Encodable {
        let spanDatas = batch as! [SpanData]
        let zipKinBatch: [ZipkinSpan] = spanDatas.map { spanData in
            let zipkinSpan = ZipkinSpan.create(from: spanData)
            return zipkinSpan
        }
        let session = URLSession(configuration: .default)
        guard let url = URL(string: endPoint + api) else {
            completion(.failure(.network(msg: "Invalid end point")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: Make the JSON output more readable
        do {
            let jsonData = try encoder.encode(zipKinBatch)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("[Span Exported]: \(jsonString)")
            }
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            session.dataTask(with: request as URLRequest) { data, response, error in
                if let error = error {
                    completion(.failure(.network(msg: "Error: \(error)")))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.network(msg: "Invalid response")))
                    return
                }
                guard response.statusCode == 202 else {
                    completion(.failure(.network(msg: "Invalid response code: \(response.statusCode)")))
                    return
                }
                completion(.success(batch))
            }.resume()
        } catch {
            completion(.failure(.dataError(msg: "[Span Exported]: Error encoding JSON: \(error)")))
        }
    }
}

extension ZipkinTraceExporter: ProcedureEndable {
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
