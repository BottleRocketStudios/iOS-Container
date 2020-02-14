//
//  ContainerViewControllerDelegate.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public protocol ContainerViewControllerDelegate: class {
    
    func containerViewController(_ container: ContainerViewController,
                                 animationControllerForTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> UIViewControllerAnimatedTransitioning?
    func containerViewController(_ container: ContainerViewController,
                                 interactionControllerForTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> ContainerViewControllerInteractiveTransitioning?
    
    func containerViewController(_ container: ContainerViewController, shouldTransitionFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child) -> Bool
    func containerViewController(_ container: ContainerViewController, didBeginTransitioningFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child)
    func containerViewController(_ container: ContainerViewController, didFinishTransitioningFrom source: ContainerViewController.Child,
                                 to destination: ContainerViewController.Child)
}

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
