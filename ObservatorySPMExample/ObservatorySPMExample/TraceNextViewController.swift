//
//  TraceNextViewController.swift
//  ObservatorySPMExample
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2024/6/10.
//

import UIKit
#if canImport(ObservatoryTracing)
import ObservatoryTracing
#endif
#if canImport(ObservatoryCommon)
import ObservatoryCommon
#endif
#if canImport(Observatory)
import Observatory
#endif

class TraceNextViewController: UIViewController {
    
    var superSpan: ReadableSpan?
    
    private var span: ReadableSpan?
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Trace action", for: .normal)
        button.addTarget(self, action: #selector(traceActionButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(actionButton)
        actionButton.frame = CGRectMake(0, 0, 120, 55)
        actionButton.center = view.center
        view.backgroundColor = .white
        title = "Tracing Next Page"
        let sampleAttri = [ObservatoryKeyValue(key: "controller_name", value: .string("TraceNextViewController"))]
        span = self.obs.spanStart(name: "demo_life_cycle", kind: .client, parentContext: superSpan?.context, attributes: sampleAttri, traceStateStr: nil)
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

extension TraceNextViewController {
    @objc private func traceActionButtonAction() {
        span?.addEvent(name: "TraceActionButtonTapped", attributes: nil)
        let testVC = TraceTableViewController()
        testVC.superSpan = span
        navigationController?.pushViewController(testVC, animated: true)
    }
}
