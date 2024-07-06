//
//  ViewController.swift
//  Observatory
//
//  Created by RavenDeng on 10/05/2023.
//  Copyright (c) 2023 RavenDeng. All rights reserved.
//

import UIKit
#if canImport(Observatory)
import Observatory
#endif

enum LogModuleCases: CaseIterable {
    case plainLog
    case tracing
    case exportingTracingData
}

extension LogModuleCases {
    var moduleName: String {
        switch self {
        case .plainLog:
            return "plain_log_module"
        case .tracing:
            return "tracing"
        case .exportingTracingData:
            return "export_tracing_data_from_sandbox"
        }
    }
}

class ViewController: UIViewController {
    
    private let cellIdentifier = "log_cell_identifier"
    
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Log function module select"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogModuleCases.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logModule = LogModuleCases.allCases[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = logModule.moduleName
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let logModule = LogModuleCases.allCases[indexPath.row]
        switch logModule {
        case .plainLog:
            let controller = LogSendViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .tracing:
            let controller = TracingDemoViewController()
            controller.title = "Subpage index 0"
            navigationController?.pushViewController(controller, animated: true)
            break
        case .exportingTracingData:
            Observatory.SandBoxDataWriter.exportSavedDataFromSandBox(searchPath: .documentDirectory, subDir: "zipkinSpans") { filePaths in
                guard let filePaths = filePaths, !filePaths.isEmpty else {
                    return
                }
                var results = [URL]()
                for filePath in filePaths {
                    do {
                        if let outputContent = try SandBoxDataWriter.formattedDataForExport(filePath) {
                            let fileManager = FileManager.default
                            guard let basePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                                return
                            }
                            var exportPath = basePath.appendingPathComponent(filePath.lastPathComponent, isDirectory: false)
                            exportPath.deletePathExtension()
                            exportPath.appendPathExtension("json")
                            try outputContent.write(to: exportPath)
                            results.append(exportPath)
                        }
                    } catch {
                        continue
                    }
                }
                let activityViewController = UIActivityViewController(activityItems: results, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true)
            }
            break
        }
        
    }
}

