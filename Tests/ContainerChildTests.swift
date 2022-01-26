//
//  ContainerChildTests.swift
//  Tests
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import Container

final class ContainerChildTests: XCTestCase {
    
    func testChildIdentifier_testEqualityBasedOnRawValue() {
        let idA = ContainerViewController.Child.Identifier(rawValue: "abc")
        let idB = ContainerViewController.Child.Identifier(rawValue: "abc")
        
        XCTAssertEqual(idA, idB)
    }
    
    func testChildIdentifier_testInequalityBasedOnRawValue() {
        let idA = ContainerViewController.Child.Identifier(rawValue: "abc")
        let idB = ContainerViewController.Child.Identifier(rawValue: "abd")
        
        XCTAssertNotEqual(idA, idB)
    }
    
    func testChildIdentifier_testHashesToSameValueBasedOnRawValue() {
        let hashA = ContainerViewController.Child.Identifier(rawValue: "abc").hashValue
        let hashB = ContainerViewController.Child.Identifier(rawValue: "abc").hashValue
        
        XCTAssertEqual(hashA, hashB)
    }
    
    func testChildIdentifier_testHashesToDifferentValueBasedOnRawValue() {
        let hashA = ContainerViewController.Child.Identifier(rawValue: "abc").hashValue
        let hashB = ContainerViewController.Child.Identifier(rawValue: "abd").hashValue
        
        XCTAssertNotEqual(hashA, hashB)
    }
    
    func testChild_testEqualityBasedOnIdentifier() {
        let childA = ContainerViewController.Child(identifier: "abc", viewController: UIViewController())
        let childB = ContainerViewController.Child(identifier: "abc", viewController: UIViewController())
        
        XCTAssertEqual(childA, childB)
    }
    
    func testChild_testInequalityBasedOnIdentifier() {
        let viewController = UIViewController()
        let childA = ContainerViewController.Child(identifier: "abc", viewController: viewController)
        let childB = ContainerViewController.Child(identifier: "abcd", viewController: viewController)

        XCTAssertNotEqual(childA, childB)
    }
    
    func testChild_testHashesToSameValueBasedOnRawValue() {
        let hashA = ContainerViewController.Child(identifier: "abc", viewController: UIViewController()).hashValue
        let hashB = ContainerViewController.Child(identifier: "abc", viewController: UIViewController()).hashValue

        XCTAssertEqual(hashA, hashB)
    }

    func testChild_testHashesToDifferentValueBasedOnRawValue() {
        let viewController = UIViewController()
        let hashA = ContainerViewController.Child(identifier: "abc", viewController: viewController).hashValue
        let hashB = ContainerViewController.Child(identifier: "abcd", viewController: viewController).hashValue

        XCTAssertNotEqual(hashA, hashB)
    }
}
