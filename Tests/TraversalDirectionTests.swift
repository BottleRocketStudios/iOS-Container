//
//  TraversalDirectionTests.swift
//  Tests
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import Container

final class TraversalDirectionTests: XCTestCase {
    
    func testChildTraversal_properlyTraversesInFollowingDirection() {
        let direction: ContainerViewController.ChildManager.TraversalDirection = .following
        
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController()),
                                                         .init(identifier: "b", viewController: UIViewController()),
                                                         .init(identifier: "c", viewController: UIViewController())]
        
        let childB = direction.nextChild(in: children, from: children[0])
        XCTAssertEqual(childB, children[1])
        
        let childC = direction.nextChild(in: children, from: children[1])
        XCTAssertEqual(childC, children[2])
    }
    
    func testChildTraversal_returnsNilWhenTraversingForwardPastArrayEnd() {
        let direction: ContainerViewController.ChildManager.TraversalDirection = .following
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController())]
        let childB = direction.nextChild(in: children, from: children[0])
        
        XCTAssertNil(childB)
    }
    
    func testChildTraversal_returnsNilWhenTraversingForwardFromObjectNotInArray() {
        let direction: ContainerViewController.ChildManager.TraversalDirection = .following
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController())]
        let childB = direction.nextChild(in: children, from: .init(identifier: "b", viewController: UIViewController()))
        
        XCTAssertNil(childB)
    }
    
    func testChildTraversal_properlyTraversesInPreceedingDirection() {
        let direction: ContainerViewController.ChildManager.TraversalDirection = .preceeding
        
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController()),
                                                         .init(identifier: "b", viewController: UIViewController()),
                                                         .init(identifier: "c", viewController: UIViewController())]
        
        let childB = direction.nextChild(in: children, from: children[2])
        XCTAssertEqual(childB, children[1])
        
        let childA = direction.nextChild(in: children, from: children[1])
        XCTAssertEqual(childA, children[0])
    }
    
    func testChildTraversal_returnsNilWhenTraversingBackwardPastArrayStart() {
        let direction: ContainerViewController.ChildManager.TraversalDirection = .preceeding
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController())]
        let previousChild = direction.nextChild(in: children, from: children[0])
        
        XCTAssertNil(previousChild)
    }
    
    func testChildTraversal_returnsNilWhenTraversingBackwardFromObjectNotInArray() {
        let direction: ContainerViewController.ChildManager.TraversalDirection = .preceeding
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController())]
        let previousChild = direction.nextChild(in: children, from: .init(identifier: "b", viewController: UIViewController()))
        
        XCTAssertNil(previousChild)
    }
}
