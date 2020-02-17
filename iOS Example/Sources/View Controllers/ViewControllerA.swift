//
//  ViewControllerA.swift
//  iOS Example
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import Container

class ViewControllerA: UIViewController, LifecycleLogging {
    
    var shouldLogLifecycleEvents: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureSubviews()
        logEvent("View A Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logEvent("View A Will Appear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logEvent("View A Will Layout Subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logEvent("View A Did Layout Subviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEvent("View A Did Appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logEvent("View A Did Disappear")
    }
}

// MARK: Helper
private extension ViewControllerA {

    func configureSubviews() {
        let newView = UILabel(frame: .zero)
        newView.text = "A"
        newView.textAlignment = .center
        newView.font = UIFont.systemFont(ofSize: 100)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = .yellow

        view.addSubview(newView)
        NSLayoutConstraint.activate([newView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     newView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     newView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     newView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
}
