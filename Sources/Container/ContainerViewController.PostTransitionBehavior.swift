//
//  ContainerViewController.PostTransitionBehavior.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

extension ContainerViewController {

    // MARK: Subtypes
    public enum PostTransitionBehavior {
        case none
        case custom((ContainerViewController.ChildManager, Child) -> Void)
        
        func execute(with childManager: ChildManager, for visible: Child) {
            switch self {
            case .none: break
            case .custom(let handler): handler(childManager, visible)
            }
        }
        
        // MARK: Convenience
        public static let removeAllNonVisibleChildren: PostTransitionBehavior = .removeAllNonVisibleChildren(exceptWithIdentifiers: [])
        public static func removeAllNonVisibleChildren(exceptWithIdentifiers identifiers: [ContainerViewController.Child.Identifier]) -> PostTransitionBehavior {
            return .custom { childManager, visibleChild in
                return childManager.removeAll(where: { $0 != visibleChild && !identifiers.contains($0.identifier) })
            }
        }

    }
}
