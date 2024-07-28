//
//  TraceTableViewController.swift
//  Observatory_Example
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2024/7/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
#if canImport(ObservatoryPod)
import ObservatoryPod
#endif
#if canImport(ObservatoryTracing)
import ObservatoryTracing
import ObservatoryCommon
#endif

struct Student {
    let name: String
    let age: Int
    let classNo: Int
    let gender: String
}

class TraceTableViewController: UITableViewController {
    
    var superSpan: ReadableSpan?
    
    private var span: ReadableSpan?
    
    private let reuseId = "studentInfoCell"
    
    private var dataSource = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        createTestDataSource()
        let sampleAttri = [ObservatoryKeyValue(key: "controller_name", value: .string("TraceTableViewController"))]
        span = self.obs.spanStart(name: "demo_life_cycle", parentContext: superSpan?.context, attributes: sampleAttri)
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
    
    private func createTestDataSource() {
        let stu1 = Student(name: "Peter", age: 18, classNo: 518000, gender: "male")
        let stu2 = Student(name: "Lisa", age: 19, classNo: 518001, gender: "female")
        let stu3 = Student(name: "Luca", age: 17, classNo: 518002, gender: "male")
        let stu4 = Student(name: "Alice", age: 19, classNo: 518003, gender: "female")
        let stu5 = Student(name: "Ryane", age: 20, classNo: 518004, gender: "male")
        let stu6 = Student(name: "Sirus", age: 20, classNo: 518005, gender: "female")
        dataSource.append(contentsOf: [stu1, stu2, stu3, stu4, stu5, stu6])
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let student = dataSource[indexPath.row]
        cell.textLabel?.text = String(format: "Name: %@ Age: %d No: %d", student.name, student.age, student.classNo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = dataSource[indexPath.row]
        let alertAttri = [
            ObservatoryKeyValue(key: "student_name", value: .string(student.name)),
            ObservatoryKeyValue(key: "age", value: .int(student.age)),
            ObservatoryKeyValue(key: "gender", value: .string(student.gender)),
            ObservatoryKeyValue(key: "No", value: .int(student.classNo))
        ]
        let currentParentSpan = self.obs.recentSpan()
        let alertSpan = self.obs.spanStart(name: "message_alert", parentContext: currentParentSpan?.context, attributes: alertAttri)
        let alertController = UIAlertController(title: student.name, message: "Message sent", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alertSpan?.addEvent(name: "tapped_ok", attributes: nil)
            alertSpan?.end()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
