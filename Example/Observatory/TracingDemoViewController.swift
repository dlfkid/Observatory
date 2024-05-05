//
//  TracingDemoViewController.swift
//  Observatory_Example
//
//  Created by LeonDeng on 2024/1/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
#if canImport(Observatory)
import Observatory
#else
import ObservatoryTracing
#endif

class TracingDemoViewController: UIViewController {
    
    private var span: ReadableSpan?

    override func viewDidLoad() {
        super.viewDidLoad()
        let sampleAttri = [ObservatoryKeyValue(key: "controller_name", value: .string("TracingDemoViewController"))]
        span = SharedTracerTool.tool.tracer.createSpan(name: "demo_life_cycle", kind: .client, attributes: sampleAttri)
        span?.addEvent(name: "life_cycle_event:viewDidLoad", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidLoad"))])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        span?.addEvent(name: "life_cycle_event:viewWillAppear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewWillAppear"))])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        span?.addEvent(name: "life_cycle_event:viewDidAppear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidAppear"))])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        span?.addEvent(name: "life_cycle_event:viewWillDisappear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewWillDisappear"))])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        span?.addEvent(name: "life_cycle_event:viewDidDisappear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidDisappear"))])
    }
    
    deinit {
        span?.addEvent(name: "life_cycle_event:deinit", attributes: [ObservatoryKeyValue(key: "name", value: .string("deinit"))])
        span?.end()
    }
}
