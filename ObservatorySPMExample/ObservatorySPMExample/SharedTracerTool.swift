//
//  SharedTracerTool.swift
//  ObservatorySPMExample
//
//  Created by Ravendeng on 2024/4/21.
//

import Foundation
import ObservatoryTracing

class SharedTracerTool {
    
    public var tracer: Tracerable {
        return tracerProvider.createTracerIfNeeded(name: "traceDemo", version: "0.1.0", schemaURL: nil, attributes: nil)
    }
    
    private lazy var tracerProvider: TracerProvidable = {
        let resource = DemoResource.sharedResource
        let processor = SimpleSpanProcessor()
        processor.debugOutPutHandler = { event in
            print(event.localizedDescription)
        }
        let builder = TracerProviderBuilder(resource: resource).configSampler(sampler: SimpleSampler()).addSpanProcessable(processor)
        return builder.build()
    }()
    
    static let tool = SharedTracerTool()
}
