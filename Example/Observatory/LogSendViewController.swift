//
//  LogSendViewController.swift
//  Observatory_Example
//
//  Created by LeonDeng on 2023/10/28.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import Observatory

class LogSendViewController: UIViewController {
    
    private var logContent: String = ""
    
    lazy private var loggerProvider: LoggerProvidable = {
        let resource = Resource(serviceName: "demmoTelemetry", nameSpace: "plainLogger", instanceId: "LogSendViewController", version: "0.1.0", otherAttributes: nil)
        let provider = LoggerProviderBuilder(resource: resource).build()
        return provider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Log send"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(rightBarButtonItemDidTappedAction))
        
    }

}

extension LogSendViewController {
    
    @objc func rightBarButtonItemDidTappedAction() {
        
    }
}
