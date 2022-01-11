//
//  LifecycleLogging.swift
//  iOS Example
//
//  Created by Will McGinty on 2/17/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import Foundation

protocol LifecycleLogging {
    var shouldLogLifecycleEvents: Bool { get set }
}

// MARK: Default Implementation
extension LifecycleLogging {

    func logEvent(_ message: String) {
        if shouldLogLifecycleEvents {
            debugPrint(message)
        }
    }
}
