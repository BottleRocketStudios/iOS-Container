//
//  ContainerViewControllerDelegate.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public protocol ContainerViewControllerDelegate: class {

    /// Asks your delegate for the transition animator object to use when transitioning between two child view controllers.
    /// - Parameters:
    ///   - container: The `ContainerViewController` instance hosting the transition.
    ///   - source: The `Child` acting as the source of the transition.
    ///   - destination: The `Child` acting as the destination of the transition.
    func containerViewController(_ container: ContainerViewController,
                                 animationControllerForTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> UIViewControllerAnimatedTransitioning?

    /// Asks your delegate for the transition interactor object to use when presenting a view controller.
    /// - Parameters:
    ///   - container: The `ContainerViewController` instance hosting the transition.
    ///   - source: The `Child` acting as the source of the transition.
    ///   - destination: The `Child` acting as the destination of the transition.
    func containerViewController(_ container: ContainerViewController,
                                 interactionControllerForTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> ContainerViewControllerInteractiveTransitioning?

    /// Called to let you fine tune the situations in which the container is allowed to transition.
    /// - Parameters:
    ///   - container: The `ContainerViewController` instance hosting the transition.
    ///   - source: The `Child` acting as the source of the transition.
    ///   - destination: The `Child` acting as the destination of the transition.
    func containerViewController(_ container: ContainerViewController, shouldTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> Bool

    /// Tells the delegate that the container has just started transitioning.
    /// - Parameters:
    ///   - container: The `ContainerViewController` instance hosting the transition.
    ///   - source: The `Child` acting as the source of the transition.
    ///   - destination: The `Child` acting as the destination of the transition.
    func containerViewController(_ container: ContainerViewController, didBeginTransitioningFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child)

    /// Tells the delegate that the container has just finished transitioning.
    /// - Parameters:
    ///   - container: The `ContainerViewController` instance hosting the transition.
    ///   - source: The `Child` acting as the source of the transition.
    ///   - destination: The `Child` acting as the destination of the transition.
    func containerViewController(_ container: ContainerViewController, didFinishTransitioningFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child)
}

// MARK: Default Implementations
public extension ContainerViewControllerDelegate {
    
    func containerViewController(_ container: ContainerViewController,
                                 animationControllerForTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> UIViewControllerAnimatedTransitioning? { return nil }
    func containerViewController(_ container: ContainerViewController,
                                 interactionControllerForTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> ContainerViewControllerInteractiveTransitioning? { return nil }
    
    func containerViewController(_ container: ContainerViewController, shouldTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> Bool { return true }
    func containerViewController(_ container: ContainerViewController, didBeginTransitioningFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) { }
    func containerViewController(_ container: ContainerViewController, didFinishTransitioningFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) { }
}
