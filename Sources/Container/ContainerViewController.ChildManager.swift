//
//  ContainerViewController.ChildManager.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension ContainerViewController {
    
    // MARK: Child Subtype

    /// Describes the objects stored by the `ContainerViewController`, each representing a combination of a single child `UIViewController` and an associated identifier.
    struct Child: Hashable {
    
        // MARK: Subtypes

        /// The identifier for a `Child` stored by the `ContainerVewController`. This type is used for the storage of these `Child` objects, and is only source for equality between `Child` objects.
        public struct Identifier: RawRepresentable, ExpressibleByStringLiteral, Hashable {
            public let rawValue: String
            
            // MARK: Initializers
            public init(rawValue: String) { self.rawValue = rawValue }
            public init(stringLiteral: String) { self.rawValue = stringLiteral }
        }
        
        // MARK: Properties

        /// The identifier of the child. This property is used to uniquely identify this `Child` amongst others. While it is possible to add multiple children with the same `Identifier`, it may result in undefined behavior.
        public let identifier: Identifier

        /// The `UIViewController` associated with this child. It is embedded as a child view controller of the `ContainerViewController` itself when presented.
        public let viewController: UIViewController

        // MARK: Initializer

        /// Initializes a new `Child` object with a given `identifier` and `viewConroller`.
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

    /// This type manages the `Child` objects embedded in the `ContainerViewController` on behalf of the container. It contains functionality to add new children, remove existing children
    /// and to query the current set of existing children. Modifying this object directly will NOT affect the `ContainerViewController` itself. The container will direct its `ChildManager`
    /// to take the appropriate actions when necessary.
    class ChildManager {

        /// Describes the method in which a new `Child` is inserted into the `ChildManager` storage.
        public enum InsertionBehavior {

            /// Describes a custom behavior that describes the addition of a new `Child`. This behavior is given access to the existing list of `Child` objects as well as the new child, and is expected to return the updated list of children.
            case custom((_ existing: [Child], _ new: Child) -> [Child])
            
            // MARK: Convenience

            /// This behavior inserts the new child at the front of the list of children. It does not conduct a uniqueness check.
            public static let `default` = InsertionBehavior.custom { into, new in return [new] + into }

            /// This behavior inserts the new child at the front of the list of children, and then removes any previously added children with the same identifier.
            public static let uniqued = InsertionBehavior.custom { into, new in
                return ([new] + into).reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
            }

            /// This behavior inserts the new child and then sorts the entire list of children.
            /// - Parameter sorter: The function used to sort the updated list of `Child` objects.
            public static func sorted(_ sorter: @escaping (Child, Child) -> Bool) -> InsertionBehavior {
                return .custom { into, new in (into + [new]).sorted(by: sorter) }
            }
            
            func inserting(new: Child, into: [Child]) -> [Child] {
                switch self {
                case .custom(let behavior): return behavior(into, new)
                }
            }
        }

        //This type describes a direction of traversal across the list of children.
        public enum TraversalDirection {

            /// Traverse the list in the forward direction, moving from the `startIndex` toward the `endIndex`.
            case following

            /// Travers the list in the backward direction, moving from the `endIndex` toward the `startIndex`.
            case preceeding
            
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

        /// The internal storage of the `Child` objects. It can not be directly modified.
        public internal(set) var children: [Child]

        /// The behavior to use when inserting new `Child` objects into the `ChildManager` storage.
        public var insertionBehavior: InsertionBehavior
        
        // MARK: Initializers

        /// Initializes a new `ChildManager` object with a given list of `Child` objects and an `InsertionBehavior`. If not provided, the `InsertionBehavior` will be `default`,
        /// which inserts the new child at the start of the list of children.
        public init(children: [Child], insertionBehavior: InsertionBehavior = .default) {
            self.children = children
            self.insertionBehavior = insertionBehavior
        }
        
        // MARK: Interface

        /// Determine if a specific `Child` is being stored by the `ChildManager`.
        /// - Parameter child: The `Child` object to be checked for containment.
        public func contains(_ child: Child) -> Bool {
            return children.contains(child)
        }

        /// Returns the first existing `Child` stored by the `ChildManager`, if one exists.
        /// - Parameter identifier: The identifier of the child to search for.
        public func existingChild(for identifier: Child.Identifier) -> Child? {
            return existingChild(where: { $0.identifier == identifier })
        }

        /// Returns the first existing `Child` stored by the `ChildManager`, if one exists.
        /// - Parameter viewController: The viewController to search for. Pointer comparison is used to identify a view controller.
        public func existingChild(for viewController: UIViewController) -> Child? {
            return existingChild(where: { $0.viewController === viewController })
        }

        /// Returns the first existing `Child` matching a predicate, if one exists.
        /// - Parameter predicate: The predicate used to search for a child.
        public func existingChild(where predicate: @escaping (Child) -> Bool) -> Child? {
            return children.first(where: predicate)
        }

        /// Returns an existing child directly adjacent to a given child, if one exists.
        /// - Parameters:
        ///   - direction: The direction in which to traverse the collection to find an adjacent child.
        ///   - child: The child at which to traverse from.
        public func existingChild(_ direction: TraversalDirection, child: Child) -> Child? {
            return direction.nextChild(in: children, from: child)
        }

        /// Returns the first index of a given child.
        /// - Parameter child: The child to search through the storage for.
        public func firstIndex(of child: Child) -> Int? {
            return children.firstIndex(of: child)
        }

        /// Returns the first index of a child matching a given predicate.
        /// - Parameter predicate: The predicate to use to search.
        public func firstIndex(where predicate: (Child) -> Bool) -> Int? {
            return children.firstIndex(where: predicate)
        }
        
        // MARK: Insertion

        /// Insert a new child into the `ChildManager` storage
        /// - Parameter child: The child object to insert into storage.
        public func insert(_ child: Child) {
            let updated = insertionBehavior.inserting(new: child, into: children)
            children = updated
        }
        
        // MARK: Removal

        /// Removes all stored `Child` objects whose identifier is equal to the
        /// - Parameter child: The `Child` to use as a baseline when deciding which stored children should be removed.
        public func remove(_ child: Child) {
            removeAll(where: { $0.identifier == child.identifier })
        }

        /// Removes all stored `Child` objects matching a predicate.
        /// - Parameter predicate: The predicate to match in order to remove managed `Child` objects.
        public func removeAll(where predicate: @escaping (Child) -> Bool) {
            children.removeAll(where: predicate)
        }
    }
}
