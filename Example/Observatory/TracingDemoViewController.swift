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

struct SubspanPageModel {
    let name: String
}

class TracingDemoViewController: UIViewController {
    
    private let reuseIdentifier = "traceDemo.reuse.identifier"
    
    private lazy var dataSource: [SubspanPageModel] = {
        var result = [SubspanPageModel]()
        for index in 1 ..< 10 {
            let name = String("Subpage index \(index)")
            let model = SubspanPageModel(name: name)
            result.append(model)
        }
        return result
    }()
    
    private var span: ReadableSpan?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let sampleAttri = [ObservatoryKeyValue(key: "controller_name", value: .string(title ?? ""))]
        span = SharedTracerTool.tool.tracer.createSpan(name: "demo_life_cycle", kind: .client, attributes: sampleAttri)
        span?.addEvent(name: "life_cycle_event:viewDidLoad", attributes: [ObservatoryKeyValue(key: "name", value: .string("viewDidLoad"))])
        view.addSubview(tableView)
        tableView.frame = view.bounds
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

extension TracingDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TracingDemoViewController()
        span?.addEvent(name: "tableview_select_event(section:\(indexPath.section), row:\(indexPath.row)", attributes: nil)
        let model = dataSource[indexPath.row]
        controller.title = model.name
        navigationController?.pushViewController(controller, animated: true)
    }
}
