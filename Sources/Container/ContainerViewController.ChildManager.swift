//
//  ContainerViewController.ChildManager.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension ContainerViewController {
    
    // MARK: Child Subtype
    struct Child: Hashable {
    
        // MARK: Subtypes
        public struct Identifier: RawRepresentable, ExpressibleByStringLiteral, Hashable {
            public let rawValue: String
            
            // MARK: Initializers
            public init(rawValue: String) { self.rawValue = rawValue }
            public init(stringLiteral: String) { self.rawValue = stringLiteral }
        }
        
        // MARK: Properties
        public let identifier: Identifier
        public let viewController: UIViewController
        
        public init(identifier: Identifier, viewController: UIViewController) {
            self.identifier = identifier
            self.viewController = viewController
        }
        
        // MARK: Equatable
        public static func == (lhs: Child, rhs: Child) -> Bool {
            return lhs.identifier == rhs.identifier
        }
                
        // MARK: Hashable
        public func hash(into: inout Hasher) {
            into.combine(identifier)
        }
    }

    // MARK: ChildManager Subtype
    class ChildManager {
        
        public enum InsertionBehavior {
            case custom(([Child], Child) -> [Child])
            
            // MARK: Convenience
            public static let `default` = InsertionBehavior.custom { into, new in return [new] + into }
            public static func sorted(_ sorter: @escaping (Child, Child) -> Bool) -> InsertionBehavior {
                return .custom { into, new in (into + [new]).sorted(by: sorter) }
            }
            
            func inserting(new: Child, into: [Child]) -> [Child] {
                switch self {
                case .custom(let behavior): return behavior(into, new)
                }
            }
        }
        
        public enum TraversalDirection {
            case following, preceeding
            
            func nextChild(in children: [Child], from: Child) -> Child? {
                switch self {
                case .following:
                    return children.firstIndex(of: from)
                        .flatMap { children.index($0, offsetBy: 1, limitedBy: children.endIndex - 1) }.map { children[$0] }
                case .preceeding:
                    return children.firstIndex(of: from)
                        .flatMap { children.index($0, offsetBy: -1, limitedBy: children.startIndex) }.map { children[$0] }
                }
            }
        }
        
        // MARK: Properties
        public internal(set) var children: [Child]
        public var insertionBehavior: InsertionBehavior
        
        // MARK: Initializers
        public init(children: [Child], insertionBehavior: InsertionBehavior = .default) {
            self.children = children
            self.insertionBehavior = insertionBehavior
        }
        
        // MARK: Interface
        public func contains(_ child: Child) -> Bool {
            return children.contains(child)
        }
        
        public func existingChild(with identifier: Child.Identifier) -> Child? {
            return existingChild(where: { $0.identifier == identifier })
        }
        
        public func existingChild(with viewController: UIViewController) -> Child? {
            return existingChild(where: { $0.viewController == viewController })
        }
        
        public func existingChild(where predicate: @escaping (Child) -> Bool) -> Child? {
            return children.first(where: predicate)
        }
        
        public func existingChild(_ direction: TraversalDirection, child: Child) -> Child? {
            return direction.nextChild(in: children, from: child)
        }
        
        public func firstIndex(of child: Child) -> Int? {
            return children.firstIndex(of: child)
        }
        
        public func firstIndex(where predicate: (Child) -> Bool) -> Int? {
            return children.firstIndex(where: predicate)
        }
        
        // MARK: Insertion
        public func insert(_ child: Child) {
            let updated = insertionBehavior.inserting(new: child, into: children)
            children = updated
        }
        
        // MARK: Removal
        public func remove(_ child: Child) {
            removeAll(where: { $0.identifier == child.identifier })
        }
        
        public func removeAll(where predicate: @escaping (Child) -> Bool) {
            children.removeAll(where: predicate)
        }
    }
}
