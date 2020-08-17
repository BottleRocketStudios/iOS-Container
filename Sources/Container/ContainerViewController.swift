//
//  ContainerViewController.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
    
    // MARK: Properties

    /// The child manager stores and controls the children of this container. It is the main access point to modification of the embedded children.
    public let childManager = ChildManager(children: [])

    /// Indicates whether the container is currently in the process of transitioning.
    open private(set) var isTransitioning: Bool = false

    /// Determines if the container should automatically load and display it's first child when it's view loads, if one exists. If this value is true, the first
    /// child in the `ChildManager` will be displayed. If false, the container will wait for further instruction.
    open var shouldAutomaticallyTransitionOnLoad: Bool = true

    /// Describes the container's behavior after each transition. Defaults to `.none`.
    open var postTransitionBehavior: PostTransitionBehavior = .none

    /// Describes the `ChildManager`s behavior when inserting new `Child` objects. Defaults to inserting them at the start of the collection.
    open var insertionBehavior: ChildManager.InsertionBehavior {
        get { return childManager.insertionBehavior }
        set { childManager.insertionBehavior = newValue }
    }

    /// The currently visible `UIViewController`.
    open var visibleViewController: UIViewController? { visibleChild?.viewController }

    /// The currently visible `Child`. Setting this variable will result in the container transitioning to the given child.
    open var visibleChild: Child? {
        didSet { visibleChild.map { transition(to: $0) } }
    }

    /// A delegate object, conforming to `ContainerViewControllerDelegate`, which provides optional transition animators, as well as call backs when transitioning starts and ends,
    open weak var delegate: ContainerViewControllerDelegate?
    
    // MARK: Transitioning
    private var containerTransitionContext: UIViewControllerContextTransitioning?
    open var containerTransitionCoordinator: ContainerViewControllerTransitionCoordinator?
    
    // MARK: Initializers

    /// Creates a new `ContainerViewController` with the given initial set of `Child` objects and an optional delegate.
    public convenience init(children: [Child], delegate: ContainerViewControllerDelegate? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.childManager.children = children
        self.delegate = delegate
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if shouldAutomaticallyTransitionOnLoad, let initial = childManager.children.first {
            transition(to: initial)
        }
    }
    
    // MARK: Interface

    /// Transitions the container to the first existing child matching the given identifier, if one exists.
    /// - Parameters:
    ///   - identifier: The identifier of the `Child` to display.
    ///   - completion: A callback executed on completion of the transition. If a `Child` with the given identifier is not found, the completion is not executed.
    open func transitionToChild(for identifier: Child.Identifier, completion: ((Bool) -> Void)? = nil) {
        childManager.existingChild(for: identifier).map { transition(to: $0, completion: completion) }
    }

    /// Transitions to the given `Child`. If the child is not currently stored as part of the `ChildManager`, then it is inserted before display.
    /// - Parameters:
    ///   - child: The `Child` to display.
    ///   - completion: A callback executed on completion of the transition.
    open func transition(to child: Child, completion: ((Bool) -> Void)? = nil) {
        if !childManager.contains(child) {
            childManager.insert(child)
        }
        
        performTransition(to: child, completion: completion)
    }
}

// MARK: Transitioning
private extension ContainerViewController {
    
    func performTransition(to destination: Child, completion: ((Bool) -> Void)? = nil) {
        
        //Ensure that the view is loaded, we're not already transitioning and the transition will result in a move to a new child
        guard isViewLoaded && !isTransitioning, visibleChild != destination else { completion?(true); return }
        guard let source = visibleChild else {
            
            //If we do not already have a visible controller (first load), skip the animator and add the child
            prepareForTransitioning(from: nil, to: destination, animated: false)
            configure(destination: destination, inContainer: view)
            finishTransitioning(from: nil, to: destination, completed: true, animated: false)
    
            completion?(true); return
        }
        
        guard delegate?.containerViewController(self, shouldTransitionFrom: source, to: destination) ?? true else { completion?(false); return }
        prepareForTransitioning(from: source, to: destination, animated: true)

        let context = configuredTransitionContext(from: source, to: destination, completion: completion)
        let animator = delegate?.containerViewController(self, animationControllerForTransitionFrom: source, to: destination) ?? DefaultContainerTransitionAnimator()
        let interactor = delegate?.containerViewController(self, interactionControllerForTransitionFrom: source, to: destination)
        
        containerTransitionCoordinator = ContainerTransitionCoordinator(context: context, animator: animator, interactor: interactor)
        if let interactor = interactor, interactor.wantsInteractiveStart {
            interactor.startInteractiveTransition(context, using: animator)
        } else {
            animator.animateTransition(using: context)
        }
        
        delegate?.containerViewController(self, didBeginTransitioningFrom: source, to: destination)
    }
}

// MARK: Helper
private extension ContainerViewController {
    
    func configuredTransitionContext(from source: Child, to destination: Child, completion: ((Bool) -> Void)?) -> ContainerTransitionContext {
        let context = ContainerTransitionContext(containerView: view, fromViewController: source.viewController, toViewController: destination.viewController)
        context.completion = { [weak context, weak self] finished in
            guard let context = context, let self = self else { return }
            
            self.finishTransitioning(from: source, to: destination, completed: !context.transitionWasCancelled, animated: true)
            self.visibleChild.map { self.postTransitionBehavior.execute(with: self.childManager, for: $0) }
            
            self.delegate?.containerViewController(self, didFinishTransitioningFrom: source, to: destination)
            completion?(finished)
        }
        
        return context
    }
    
    func prepareForTransitioning(from source: Child?, to destination: Child, animated: Bool) {
        isTransitioning = true
        
        source?.viewController.beginAppearanceTransition(false, animated: animated)
        destination.viewController.beginAppearanceTransition(true, animated: animated)
        
        addChild(destination.viewController)
        destination.viewController.didMove(toParent: self)
    }
    
    func configure(destination: Child, inContainer container: UIView) {
        ///It is the animator's responsibility (as with all `UIViewControllerAnimatedTransitioning` objects) to add the destinationView as a subview of the container view.
        ///The container will simply ensure the proper layout is used once the transition is completed.
        
        container.addSubview(destination.viewController.view)
        destination.viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destination.viewController.view.frame = container.bounds
    }
    
    func finishTransitioning(from source: Child?, to destination: Child, completed: Bool, animated: Bool) {
        func finishTransitioningOut(for viewController: UIViewController?) {
            viewController?.willMove(toParent: nil)
            viewController?.view.removeFromSuperview()
            viewController?.removeFromParent()
        }
        
        if completed {
            finishTransitioningOut(for: source?.viewController)
            visibleChild = destination
        } else {
            finishTransitioningOut(for: destination.viewController)
            visibleChild = source
        }
        
        destination.viewController.endAppearanceTransition()
        source?.viewController.endAppearanceTransition()
        
        containerTransitionContext = nil
        isTransitioning = false
    }
}
