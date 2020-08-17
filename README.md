# Container

[![CI Status](http://img.shields.io/travis/bottlerocketstudios/Container.svg?style=flat)](https://travis-ci.org/bottlerocketstudios/iOS-Container)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/bottlerocketstudios/iOS-Container)
[![License](https://img.shields.io/github/license/bottlerocketstudios/iOS-Container)](LICENSE)

The `ContainerViewController` is designed to be a simple but flexible method to embed and transition between multiple child `UIViewController` objects. It was built to fill in the gap when you need a `UINavigationController` without the hassle of a navigation bar, or a `UITabBarController` without the tab bar. The only built in way to transition between children of the container is through its `transition(to:)` API.

To get started quickly, it is easiest to create the `ContainerViewController` from code and manually add it as a child of a parent `UIViewController`. This is easily done in that view controller's `viewDidLoad` function:

``` swift
private lazy var containerViewController: ContainerViewController = ContainerViewController(children: [.init(identifier: .a, viewController: controllerA), 
                                                                                                       .init(identifier: .b, viewController: controllerB)], delegate: self)

containerViewController.willMove(toParent: self)

addChild(containerViewController)
containerView.addSubview(containerViewController.view)
containerViewController.view.frame = containerView.bounds

containerViewController.didMove(toParent: self)
```

You'll notice that in this example we were able to use static typed identifier's, `.a` and `.b`. This is because of an extension declared on `ContainerViewController.Child.Identifier`, simply:

``` swift
extension ContainerViewController.Child.Identifier {
    static let a = ContainerViewController.Child.Identifier(rawValue: "A")
    static let b = ContainerViewController.Child.Identifier(rawValue: "B")
}
```

Although this is is encouraged, `ContainerViewController.Child.Identifier` conforms to `ExpressibleByStringLiteral` and `RawRepresentable` so these identifiers can be initialized from any `String` at run time.

Once you have the `ContainerViewController` properly initialized and visible, it will (by default) automatically transition to its first `Child`. This behavior is controlled by the `shouldAutomaticallyTransitionOnLoad`, where, when set to `true`, the container will select the first of its `Child` objects when its view loads. If this value is set to false, or the `ContainerViewController` has no `Child` objects at load time, it will wait for further instruction before embedding and showing a `Child`.

In order to begin showing a child view controller, there are a few options:

``` swift

// If `child` is not already part of `ContainerViewController`, it will be added before it is displayed
let child = ContainerViewController.Child(identifier: .new, viewController: someViewController)
containerViewController.transition(to: child) { finished in
    print("finished transitioning: \(finished)")
}

// If you know the identifier of an existing `Child` that is part of the container, you can alternatively request it:
containerViewController.transitionToChild(for: .new) { finished in
    print("finished transitioning: \(finished)")
}
```

The container also has several delegate callbacks which can help customize its behavior. Among them, is a function which returns a `UIViewControllerAnimatedTransitioning` object, which is used identically to those used in modal, navigation and tab transition animations.

``` swift
func containerViewController(_ container: ContainerViewController, animationControllerForTransitionFrom source: Child, to destination: Child) -> UIViewControllerAnimatedTransitioning? {
    if useCustomAnimator, let sourceIndex = container.index(ofChild: source.viewController), let destinationIndex = container.index(ofChild: destination.viewController) {
        return WipeTransitionAnimator(withStartIndex: sourceIndex, endIndex: destinationIndex)
    }

    return nil
}
``` 


## Inspiration

Container is an evolution of the `ContainerViewController` that was available as part of [UtiliKit](https://github.com/BottleRocketStudios/iOS-UtiliKit). For the most part, the two are source-compatible, but please check out our [migration guide](./Documentation/Migrations/Container%201.0%20Migration%20Guide.md) if you're upgrading to Container from UtiliKit.

## Example

To run the example project, clone this repo and open `iOS Example/iOS Example.xcworkspace`.

## Requirements

Requires iOS 10.0, tvOS 10.0


## Installation

Add this to your project using Swift Package Manager. In Xcode that is simply: File > Swift Packages > Add Package Dependency... and you're done. Alternative installations options are shown below for legacy projects.

### CocoaPods

If you are already using [CocoaPods](http://cocoapods.org), just add 'Container' to your `Podfile` then run `pod install`.

### Carthage

If you are already using [Carthage](https://github.com/Carthage/Carthage), just add to your `Cartfile`:

```ogdl
github "BottleRocketStudios/Container" ~> 0.1
```

Then run `carthage update` to build the framework and drag the built `Container`.framework into your Xcode project.


## Author

[Bottle Rocket Studios](https://www.bottlerocketstudios.com/)


## License

Container is available under the Apache 2.0 license. See [the LICENSE file](LICENSE) for more information.


## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/BottleRocketStudios/iOS-Container/graphs/contributors
