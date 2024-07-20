//
//  SharedTracerTool.swift
//  ObservatorySPMExample
//
//  Created by Ravendeng on 2024/4/21.
//

import Foundation
#if canImport(ObservatoryTracing)
import ObservatoryTracing
#else
import Observatory
#endif
#if canImport(ZipkinExport)
import ZipkinExport
#endif

class SharedTracerTool {
    
    public var tracer: Tracerable {
        return tracerProvider.createTracerIfNeeded(name: "traceDemo", version: "0.1.0", schemaURL: nil, attributes: nil)
    }
    
    private lazy var tracerProvider: TracerProvidable = {
        let resource = DemoResource.sharedResource
//        let exporter = ZipkinSpanStorage(serviceName: "observatory_storage_demo_service", searchPath: .documentDirectory, subdir: "zipkinSpans")
        let exporter = ZipkinSpanExporter(serviceName: "observatory_export_demo_service", host: "http://127.0.0.1", islocal: true)
        let processor = SimpleSpanProcessor<ZipkinSpanExporter>(exporter: exporter)
        processor.eventCallBackEmited = { ret, event in
            print(String(event?.localizedDescription ?? ""))
        }
        let cachePool = SpanCachePool.default
        cachePool.eventCallBackEmited = { ret, event in
            print(String(event?.localizedDescription ?? ""))
        }
        let builder = TracerProviderBuilder(resource: resource).configSampler(sampler: SimpleSampler()).addSpanProcessable(processor).addSpanProcessable(cachePool)
        return builder.build()
    }()
    
    static let tool = SharedTracerTool()
}
