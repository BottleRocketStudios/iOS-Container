//
//  ContainerViewController.swift
//  Container
//
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
    
    // MARK: Properties
    public let childManager = ChildManager(children: [])
    open private(set) var isTransitioning: Bool = false

    open var shouldAutomaticallyTransitionOnLoad: Bool = true
    open var postTransitionBehavior: PostTransitionBehavior = .none
    open var insertionBehavior: ChildManager.InsertionBehavior {
        get { return childManager.insertionBehavior }
        set { childManager.insertionBehavior = newValue }
    }
    
    open var visibleViewController: UIViewController? { visibleChild?.viewController }
    open var visibleChild: Child? {
        didSet { visibleChild.map { transition(to: $0) } }
    }
    
    open weak var delegate: ContainerViewControllerDelegate?
    
    // MARK: Transitioning
    private var containerTransitionContext: UIViewControllerContextTransitioning?
    open var containerTransitionCoordinator: ContainerViewControllerTransitionCoordinator?
    
    // MARK: Initializers
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
    open func transitionToChild(for identifier: Child.Identifier, completion: ((Bool) -> Void)? = nil) {
        childManager.existingChild(with: identifier).map { transition(to: $0, completion: completion) }
    }
   
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
        //It is the animator's responsibility (as with all `UIViewControllerAnimatedTransitioning` objects) to add the destinationView as a subview of the container view. The container will simply ensure the proper layout is used once the transition is completed.
        
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
