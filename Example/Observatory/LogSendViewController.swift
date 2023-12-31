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
    
    private let loggerName = "customize_logger"
    
    private let loggerVersion = "1.0.0"
    
    lazy private var loggerProvider: LoggerProvidable = {
        let resource = ResourceBuilder() .serviceName("demmoTelemetry").nameSpace("plainLogger").instanceId("LogSendViewController").version("0.1.0").build()
        
        let exporter = SimpleLogRecordExporter()
        let processor = SimpleLogProcessor(exporter: exporter)
        
        let provider = LoggerProviderBuilder(resource: resource).addLogProcessable(processor).build()
        
        provider.createLoggerIfNeeded(name: loggerName, version: loggerVersion, schemeaURL: nil, attributes: ["type": .string("demo")])
        return provider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Log send"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(rightBarButtonItemDidTappedAction))
        
    }

}

extension LogSendViewController {
    
    @objc func rightBarButtonItemDidTappedAction() {
        loggerProvider.log("In my restless dreams, I see that tonw, silent hill, your promised you will take me there again someday, but you never did. Now I am all alone here, in our special place, waiting for you.", severity: .info, timeStamp: nil, attributes: ["game_name": .string("Silent Hill"), "generation": .int(2), "qoute_by": .string("mary")], traceID: nil, spanID: nil, flag: .unspecified, name: loggerName, version: loggerVersion, schemeaURL: nil)
    }
}
