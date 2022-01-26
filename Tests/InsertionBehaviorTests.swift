//
//  InsertionBehaviorTests.swift
//  Tests
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import Container

final class InsertionBehaviorTests: XCTestCase {
    
    func testInsertionBehavior_testCustomInsertionBehavior() {
        let exp = expectation(description: "custom insertion behavior")
        let behavior = ContainerViewController.ChildManager.InsertionBehavior.custom { into, new in
            exp.fulfill()
            return into + [new]
        }
        
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController())]
        let new: ContainerViewController.Child = .init(identifier: "b", viewController: UIViewController())
        let inserted = behavior.inserting(new: new, into: children)
        
        XCTAssertEqual(inserted, children + [new])
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testInsertionBehavior_testDefaultInsertionBehavior() {
        let behavior = ContainerViewController.ChildManager.InsertionBehavior.default
        
        let children: [ContainerViewController.Child] = [.init(identifier: "a", viewController: UIViewController())]
        let new: ContainerViewController.Child = .init(identifier: "b", viewController: UIViewController())
        let inserted = behavior.inserting(new: new, into: children)
        
        XCTAssertEqual(inserted, [new] + children)
    }
    
    func testInsertionBehavior_testSortedInsertionBehavior() {
        let behavior = ContainerViewController.ChildManager.InsertionBehavior.sorted { lhs, rhs in
            return lhs.identifier.rawValue < rhs.identifier.rawValue
        }
        
        let children: [ContainerViewController.Child] = [.init(identifier: "b", viewController: UIViewController())]
        let new: ContainerViewController.Child = .init(identifier: "a", viewController: UIViewController())
        let inserted = behavior.inserting(new: new, into: children)
        
        let new2: ContainerViewController.Child = .init(identifier: "c", viewController: UIViewController())
        let inserted2 = behavior.inserting(new: new2, into: inserted)
        
        XCTAssertEqual(inserted2, [new] + children + [new2])
    }
}
