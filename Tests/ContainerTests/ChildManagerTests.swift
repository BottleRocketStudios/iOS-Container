//
//  ChildManagerTests.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import Container

final class ChildManagerTests: XCTestCase {
    
    func testChildManager_testContainsSpecificChildBasedOnIdentifier() {
        let viewController = UIViewController()
        let childA = ContainerViewController.Child(identifier: "a", viewController: viewController)
        let manager = ContainerViewController.ChildManager(children: [childA,
                                                                      .init(identifier: "b", viewController: UIViewController())])
        
        XCTAssertTrue(manager.contains(childA))
        XCTAssertFalse(manager.contains(.init(identifier: "c", viewController: viewController)))
        XCTAssertTrue(manager.contains(.init(identifier: "a", viewController: UIViewController())))
    }
    
    func testChildManager_testRetrievesExistingChildWithIdentifier() {
        let manager = ContainerViewController.ChildManager(children: [.init(identifier: "a", viewController: UIViewController()),
                                                                      .init(identifier: "b", viewController: UIViewController())])
        
        XCTAssertNotNil(manager.existingChild(with: "a"))
        XCTAssertNotNil(manager.existingChild(with: "b"))
        XCTAssertNil(manager.existingChild(with: "c"))
    }
    
    func testChildManager_testRetrievesExistingChildWithViewController() {
        let vcA = UIViewController()
        let vcB = UIViewController()
        let manager = ContainerViewController.ChildManager(children: [.init(identifier: "a", viewController: vcA),
                                                                      .init(identifier: "b", viewController: vcB)])
        
        XCTAssertNotNil(manager.existingChild(with: vcA))
        XCTAssertNotNil(manager.existingChild(with: vcB))
        XCTAssertNil(manager.existingChild(with: UIViewController()))
    }
    
    func testChildManager_testRetrievesExistingChildWithRespectToTraversalDirection() {
        let childA = ContainerViewController.Child(identifier: "a", viewController: UIViewController())
        let childB = ContainerViewController.Child(identifier: "b", viewController: UIViewController())
        let manager = ContainerViewController.ChildManager(children: [childA, childB])
        
        XCTAssertEqual(childA, manager.existingChild(.preceeding, child: manager.children[1]))
        XCTAssertEqual(childB, manager.existingChild(.following, child: manager.children[0]))
    }
    
    func testChildManager_testRetrievesFirstIndexOfExistingChild() {
        let childA = ContainerViewController.Child(identifier: "a", viewController: UIViewController())
        let childB = ContainerViewController.Child(identifier: "b", viewController: UIViewController())
        let manager = ContainerViewController.ChildManager(children: [childA, childB])
        
        XCTAssertEqual(manager.firstIndex(of: childA), 0)
        XCTAssertEqual(manager.firstIndex(of: childB), 1)
        XCTAssertNil(manager.firstIndex(of: .init(identifier: "c", viewController: UIViewController())))
    }
    
    func testChildManager_testRetrievesFirstIndexWherePredicateMatches() {
        let childA = ContainerViewController.Child(identifier: "a", viewController: UIViewController())
        let childB = ContainerViewController.Child(identifier: "abc", viewController: UIViewController())
        let manager = ContainerViewController.ChildManager(children: [childA, childB])
        
        let indexMatching = manager.firstIndex{ $0.identifier.rawValue.count == 3 }
        XCTAssertEqual(indexMatching, 1)
    }
    
    func testChildManager_testInsertsAccordingToBehavior() {
        let childA = ContainerViewController.Child(identifier: "a", viewController: UIViewController())
        let childB = ContainerViewController.Child(identifier: "b", viewController: UIViewController())
        let manager = ContainerViewController.ChildManager(children: [childA], insertionBehavior: .default)
        
        manager.insert(childB)
        XCTAssertEqual([childB, childA], manager.children)
    }
    
    func testChildManager_testRemovalOfChildrenBasedOnIdentifier() {
        let childA = ContainerViewController.Child(identifier: "a", viewController: UIViewController())
        let childB = ContainerViewController.Child(identifier: "b", viewController: UIViewController())
        let manager = ContainerViewController.ChildManager(children: [childA, childB], insertionBehavior: .default)
        
        manager.remove(childB)
        XCTAssertEqual([childA], manager.children)
    }
}
