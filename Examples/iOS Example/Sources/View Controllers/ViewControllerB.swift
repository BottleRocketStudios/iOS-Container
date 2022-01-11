//
//  ViewControllerB.swift
//  iOS Example
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController, LifecycleLogging {
    
    var shouldLogLifecycleEvents: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        logEvent("View B Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logEvent("View B Will Appear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logEvent("View B Will Layout Subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logEvent("View B Did Layout Subviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEvent("View B Did Appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logEvent("View B Did Disappear")
    }
}
