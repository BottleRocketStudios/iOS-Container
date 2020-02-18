//
//  ContainerViewController.PostTransitionBehavior.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

extension ContainerViewController {

    // MARK: Subtypes

    /// This type describes a function or behavior that is run after a `ContainerViewController` finishes a transition.
    public enum PostTransitionBehavior {

        /// No action will be taken after each transition.
        case none

        /// Describes a custom action that will be taken after each transition. The behavior is given access to the `ChildManager` as well as the currently visible `Child` at the time of execution.
        case custom((ContainerViewController.ChildManager, Child) -> Void)
        
        func execute(with childManager: ChildManager, for visible: Child) {
            switch self {
            case .none: break
            case .custom(let handler): handler(childManager, visible)
            }
        }
        
        // MARK: Convenience

        /// This behavior will remove all `Child` objects the `ChildManager` is storing, except for the one currently visible.
        public static let removeAllNonVisibleChildren: PostTransitionBehavior = .removeAllNonVisibleChildren(exceptWithIdentifiers: [])

        /// This behavior will remove all `Child` objects the `ChildManager` is storing, except for the one currently visible and any children whose identifiers have been specified.
        /// - Parameter identifiers: A list of identifiers of `Child` objects that are excepted from removal, regardless of their visibility.
        public static func removeAllNonVisibleChildren(exceptWithIdentifiers identifiers: [ContainerViewController.Child.Identifier]) -> PostTransitionBehavior {
            return .custom { childManager, visibleChild in
                return childManager.removeAll(where: { $0 != visibleChild && !identifiers.contains($0.identifier) })
            }
        }
    }
}
