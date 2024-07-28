//
//  TracingDemoViewController.swift
//  Observatory_Example
//
//  Created by LeonDeng on 2024/1/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
#if canImport(ObservatoryTracing)
import ObservatoryTracing
#endif
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif
#if canImport(ObservatoryPod)
import ObservatoryPod
#endif

class TracingDemoViewController: UIViewController {
    
    private var span: ReadableSpan?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonAction))
        view.backgroundColor = .white
        title = "Tracing Example"
        let sampleAttri = [ObservatoryKeyValue(key: "controller_name", value: .string("TracingDemoViewController"))]
        span = SharedTracerTool.tool.tracer.createSpan(name: "demo_life_cycle", kind: .client, attributes: sampleAttri, startTimeUnixNano: nil, linkes: nil)
        span?.addEvent(name: "viewDidLoad", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidLoad"))])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        span?.addEvent(name: "viewWillAppear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewWillAppear"))])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        span?.addEvent(name: "viewDidAppear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidAppear"))])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        span?.addEvent(name: "viewWillDisappear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewWillDisappear"))])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        span?.addEvent(name: "viewDidDisappear", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidDisappear"))])
    }
    
    deinit {
        span?.addEvent(name: "deinit", attributes: [ObservatoryKeyValue(key: "name", value: .string("deinit"))])
        span?.end()
    }
}

extension TracingDemoViewController {
    @objc private func nextButtonAction() {
        span?.addEvent(name: "button_tapped", attributes: [ObservatoryKeyValue(key: "name", value: .string("next_button"))])
        let controller = TraceNextViewController()
        controller.superSpan = span
        navigationController?.pushViewController(controller, animated: true)
    }
}
