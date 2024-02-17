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

class TracingDemoViewController: UIViewController {
    
    private lazy var tracerProvider: TracerProvidable = {
        let resource = DemoResource.sharedResource
        let builder = ObservatoryTracing.TracerProviderBuilder(resource: resource)
        return builder.build()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
