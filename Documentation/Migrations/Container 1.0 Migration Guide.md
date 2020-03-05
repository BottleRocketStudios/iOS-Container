# Container 1.0 Migration Guide

This guide has been provided in order to ease the transition of existing applications using Container 1.x to the latest APIs, as well as to explain the structure of the new and changed functionality.

## Requirements

- iOS 10.0, tvOS 10.0, watchOS 10.0
- Xcode 11.0
- Swift 5.1

## Overview

Container 1.0 brings a few small improvements to the Container subspec of [`UtiliKit`](https://github.com/BottleRocketStudios/iOS-UtiliKit). The vast majority of this release is source compatible if you are migrating from `UtiliKit`. The breaking changes are detailed below:


## Breaking Changes

### `ContainerViewController.Child`

A new type `ContainerViewController.Child` has been introduced. It effectively replaces the combination of the `ManagedChild` protocol and `Child` object, and a has a few small differences in functionality. To begin with, the `Child` utilizes a `Child.Identifier` as its identifying type instead of `AnyHashable`, allowing the compiler to be much smarter when transitioning and determing which `Child` is being referred to. In order to preserve backwards compatibility as much as possible, this new type is both `ExpressibleByStringLiteral` and `Hashable`.

### `ChildManager`

In order to provide more flexibility around the management of children, a `ContainerViewController.ChildManager` type has been introduced. This object's responsibility is to manage and maintain the `ContainerViewController.Child` objects utilized by the `ContainerViewController`. Where previously a limited set of query and modification operations were availble directly on the `ContainerViewController`, these have now been replaced by a more robust suite of functionality on the `ChildManager`. A few examples:

```swift
let behavior = ContainerViewController.ChildManager.InsertionBehavior.custom { into, new in
// The default `InsertionBehavior` inserts the newest element as the first child, and a `sorted` behavior is also available.
    return into + [new]
}

let containerContainsChild = childManager.contains(myChild)

let existingChildForViewController = childManager.existingChild(with: myViewController)

let childMatchingPredicate = childManager.existingChild { $0.identifier == .myIdentifier }

let nextChild = childManager.existingChild(.following, child: myChild)
let previousChild = childManager.existingChild(.preceeding, child: myChild)
```

### `ContainerViewController`

The transitioning APIs have been slightly tweaked to account for the new `Child` structure, and are now much more expressive and compatible with autocomplete. A few examples:

```swift 
containerViewController.transitionToChild(for: .someIdentifier) { finished in 
    /// Completion
}

containerViewController.transition(to: Child(identifier: .newIdentifier, viewController: myViewController) { finished in
    /// This child will automatically be added to the container's children if it is not already
}
```

## Other Improvements

### `ContainerViewController.PostTransitionBehavior`

A new property on `ContainerViewController` now exists to execute an action after every transition finishes. For instance, you may be building a long flow of a series of `UIViewController`s using the container. In this case, you may opt to remove all the 'previous' view controllers after each transition. This is incredibly simple using the `postTransitionBehavior`:

```swift
containerViewController.postTransitionBehavior = .removeAllNonVisibleChildren
containerViewController.transitionToChild(for: .nextIdentifier)

/// All the `Child` objects of `containerViewController` will have been removed from the container.
```


