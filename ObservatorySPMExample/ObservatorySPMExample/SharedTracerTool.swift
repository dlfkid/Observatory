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
        let processor = SimpleSpanProcessor<ZipkinSpanStorage>(exporter: ZipkinSpanStorage.init(serviceName: "zipkin_local_persist", searchPath:.documentationDirectory , subdir: "tracing"))
        processor.debugOutPutHandler = { event in
            print(event.localizedDescription)
        }
        let cachePool = SpanCachePool.default
        cachePool.debugOutPutHandler = { event in
            print(event.localizedDescription)
        }
        let builder = TracerProviderBuilder(resource: resource).configSampler(sampler: SimpleSampler()).addSpanProcessable(processor).addSpanProcessable(cachePool)
        return builder.build()
    }()
    
    static let tool = SharedTracerTool()
}
