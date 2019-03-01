//
//  DrawerViewController.swift
//  Nodes
//
//  Created by Andrei Hogea on 06/08/2018.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

public class DrawerViewController: UIViewController { //swiftlint:disable:this type_body_length
    
    weak var contentViewController: (UIViewController & Embeddable)?
    weak var backgroundViewController: UIViewController?
    
    // MARK: Configuration
    
    private var embedConfig: Drawer.ContentConfiguration! {
        didSet {
            animationDuration = embedConfig.duration
            
            //drawer heights
            ownMaxHeight = embedConfig.embeddedFullHeight
            ownMinHeight = embedConfig.embeddedMinimumHeight
            heightAnchorContent.constant = ownMaxHeight
            cornerRadius = embedConfig.cornerRadius
            
            //drawer state
            state = embedConfig.state
            
            showAnimation()
        }
    }
    
    // MARK: Sizes and Constrains
    
    private var heightAnchorContent: NSLayoutConstraint!
    private var bottomAnchorContent: NSLayoutConstraint!
    private var ownMaxHeight: CGFloat = 0
    private var ownMinHeight: CGFloat = 0
    private var cornerRadius: Drawer.ContentConfiguration.CornerRadius!
    
    // MARK: States
    
    private var isInitiated: Bool = false
    private var state: Drawer.State = .minimised
    private var backgroundInteraction: Drawer.ContainerInteraction = .whenMinimised
    
    // MARK: Drawer possible backgrounds
    
    private var backgroundType: DrawerBackgroundType!
    
    private var backgroundColorView: UIView?
    private var backgroundBlurEffectView: UIVisualEffectView?
    
    // MARK: Slide Animation Properties
    
    private var animationDuration: TimeInterval!
    private let damping: CGFloat = 0.85
    // direction represents scrolling direction of the view
    private var direction: Direction!
    private var runningAnimators: [UIViewPropertyAnimator] = []
    private var animationProgress: [CGFloat] = []
    private var lastFractionComplete: CGFloat = 0
    
    // MARK: - Init
    
    public override func loadView() {
        super.loadView()
        self.view = TouchInterceptingView()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ownMaxHeight > 0 && isInitiated == false {
            DispatchQueue.main.async {
                self.showAnimation()
            }
        }
        
    }
    
    func makeViews(with backgroundType: DrawerBackgroundType) {
        self.backgroundType = backgroundType
        view.backgroundColor = .clear
        
        addDrawerToBackground()
        switch backgroundType {
        case .withBlur:
            addBlurEffectViewToDrawer()
        case .withColor:
            addColorViewToDrawer()
        default: break
        }
        addContentToDrawer()
        setupGestureRecognizers()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func roundCorners(with radius: CGFloat) {
        contentViewController?.view.layer.cornerRadius = radius
        let corners = UIRectCorner(arrayLiteral: .topLeft, .topRight)
        contentViewController?.view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
}

// MARK: - Add Children -

extension DrawerViewController {
    
    /// Adds the Drawer(self) to the backgroundViewController
    private func addDrawerToBackground() {
        guard let backgroundViewController = backgroundViewController else { return }
        
        //swiftlint:disable:next force_cast
        let touchInterceptingView = view as! TouchInterceptingView
        touchInterceptingView.delegate = self
        
        backgroundViewController.view.addSubview(view)
        willMove(toParent: backgroundViewController)
        backgroundViewController.addChild(self)
        didMove(toParent: backgroundViewController)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: maxAllowedHeight).isActive = true
        view.bottomAnchor.constraint(equalTo: backgroundViewController.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: backgroundViewController.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: backgroundViewController.view.trailingAnchor).isActive = true
    }
    
    /// Adds a UIVisualEffectView to self to act as background
    private func addBlurEffectViewToDrawer() {
        backgroundBlurEffectView = UIVisualEffectView()
        view.addSubview(backgroundBlurEffectView!)
        backgroundBlurEffectView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundBlurEffectView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundBlurEffectView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundBlurEffectView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundBlurEffectView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Adds a UIView to self to act as background
    private func addColorViewToDrawer() {
        backgroundColorView = UIView()
        view.addSubview(backgroundColorView!)
        backgroundColorView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundColorView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundColorView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundColorView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Adds a contents UIViewController's view to self
    private func addContentToDrawer() {
        guard
            contentViewController != nil
            else { return }
        
        contentViewController?.embedDelegate = self
        
        view.addSubview(contentViewController!.view)
        contentViewController?.willMove(toParent: self)
        addChild(contentViewController!)
        contentViewController?.didMove(toParent: self)
        
        contentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        heightAnchorContent = contentViewController?.view.heightAnchor.constraint(equalToConstant: maxAllowedHeight)
        heightAnchorContent.identifier = "heightAnchorContent"
        heightAnchorContent.isActive = true
        bottomAnchorContent = contentViewController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: maxAllowedHeight)
        bottomAnchorContent.identifier = "bottomAnchorContent"
        bottomAnchorContent.isActive = true
        contentViewController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentViewController?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

// MARK: - UIGestureRecognizer -

extension DrawerViewController {
    
    private func setupGestureRecognizers() {
        do {
            let gr = InstantPanGestureRecognizer.init(target: self, action: #selector(handlePan))
            gr.delegate = self
            contentViewController?.view.addGestureRecognizer(gr)
        }
    }

    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(duration: animationDuration)
        case .changed:
            let translation = recognizer.translation(in: contentViewController?.view)
            var fractionComplete = translation.y / (ownMaxHeight - ownMinHeight)
            
            switch state {
            case .fullSize:
                direction = fourDecimal(fractionComplete) >= fourDecimal(lastFractionComplete) ? .down : .up
            case .minimised:
                fractionComplete *= -1
                direction = fourDecimal(fractionComplete) >= fourDecimal(lastFractionComplete) ? .up : .down
            }

            // if we have a progress, that means that the user started the swipe during the animation
            if animationProgress[0] > 0 {
                for (index, animator) in runningAnimators.enumerated() {
                    if animator.isReversed {
                        animator.fractionComplete = -fractionComplete + animationProgress[index]
                    } else {
                        animator.fractionComplete = fractionComplete + animationProgress[index]
                    }
                }
            } else { // scroll started from initial state
                guard fractionComplete > 0 && fractionComplete < 1 else {
                    return
                }
                for (index, animator) in runningAnimators.enumerated() {
                    if animator.isReversed {
                        animator.fractionComplete = fractionComplete - animationProgress[index]
                    } else {
                        animator.fractionComplete = fractionComplete + animationProgress[index]
                    }
                }
            }
            
            // set lastFractionComplete -> used to determine pan direction
            lastFractionComplete = fractionComplete
            
            // normalise the progress and return it to the delegate
            var returnFractionComplete = runningAnimators[0].fractionComplete
            if returnFractionComplete >= 1 {
                returnFractionComplete = 1
            } else if returnFractionComplete <= 0 {
                returnFractionComplete = 0
            }
            
            contentViewController?.didScroll(with: returnFractionComplete, from: state)
            
        case .ended:
            // normal animation conditions
            if state == .fullSize && direction == .down || state == .minimised && direction == .up {
                switch state {
                case .fullSize:
                    switch direction {
                    case .down?:
                        if runningAnimators[0].isReversed {
                            runningAnimators.forEach { $0.isReversed = !$0.isReversed } // will Cancel reverse
                            contentViewController?.willChangeState(to: .minimised)
                        }
                    default: break
                    }
                case .minimised:
                    switch direction {
                    case .up?:
                        if runningAnimators[0].isReversed {
                            runningAnimators.forEach { $0.isReversed = !$0.isReversed } //will Cancel reverse
                            contentViewController?.willChangeState(to: .fullSize)
                        }
                    default: break
                    }
                }
            } else {
                // reverse the animations based on their current state and pan motion direction
                switch state {
                case .fullSize:
                    switch direction {
                    case .up?:
                        if !runningAnimators[0].isReversed {
                            runningAnimators.forEach { $0.isReversed = !$0.isReversed } //will reverse
                            contentViewController?.willChangeState(to: .fullSize)
                        }
                    default: break
                    }
                case .minimised:
                    switch direction {
                    case .down?:
                        if !runningAnimators[0].isReversed {
                            runningAnimators.forEach { $0.isReversed = !$0.isReversed } //will reverse
                            contentViewController?.willChangeState(to: .minimised)
                        }
                    default: break
                    }
                }
            }

            // continue the paused animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default: break
        }
    }
    
    private func startInteractiveTransition(duration: TimeInterval) {
        animateTransitionIfNeeded(duration: animationDuration)
        runningAnimators.forEach({ animator in
            animator.pauseAnimation()
        })
        
        animationProgress = runningAnimators.map { $0.fractionComplete }
    }
    
}

// MARK: - Content Constrains Helpers -

extension DrawerViewController {
    
    private func setupOpenConstraints() {
        guard bottomAnchorContent != nil else { return }
        bottomAnchorContent.constant = 0
    }
    
    private func setupClosedConstraints() {
        guard bottomAnchorContent != nil else { return }
        bottomAnchorContent.constant = ownMaxHeight - ownMinHeight
    }
    
    private func setupDismissConstraints() {
        guard bottomAnchorContent != nil else { return }
        bottomAnchorContent.constant = heightAnchorContent.constant
    }
    
}

// MARK: - Background Helpers -

extension DrawerViewController {
    
    private func handleOpenBackgroundAnimation() {
        switch self.backgroundType {
        case .withBlur(let style)?:
            self.backgroundBlurEffectView?.effect = UIBlurEffect(style: style)
        case .withColor(let color)?:
            backgroundColorView?.backgroundColor = color
        default: break
        }
    }
    
    
    private func handleCloseBackgroundAnimation() {
        switch self.backgroundType {
        case .withBlur?:
            self.backgroundBlurEffectView?.effect = nil
        case .withColor(let color)?:
            backgroundColorView?.backgroundColor = color.withAlphaComponent(0)
        default: break
        }
    }
}

// MARK: - Full Animations -

extension DrawerViewController {
    private func openDrawer(animated: Bool = true, completion: (() -> Void)? = nil) {
        state = .fullSize
        setupOpenConstraints()
        
        //allow for scrolling in ContentVC
        if let scrollableContent = contentViewController as? EmbeddedScrollable {
            scrollableContent.setScrollEnabled(true)
        }
        
        let duration: TimeInterval = animated ? animationDuration : 0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                completion?()
                guard let self = self else { return }
                self.roundCorners(with: self.cornerRadius.fullSize)
                self.handleOpenBackgroundAnimation()
                self.contentViewController?.didChangeState(to: .fullSize)
        })
    }
    
    private func closeDrawer(animated: Bool = true, completion: (() -> Void)? = nil) {
        state = .minimised
        setupClosedConstraints()
        
        //allow for scrolling in ContentVC
        if let scrollableContent = contentViewController as? EmbeddedScrollable {
            scrollableContent.setScrollEnabled(true)
        }
        
        let duration: TimeInterval = animated ? animationDuration : 0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            
            }, completion: { [weak self] _ in
                completion?()
                guard let self = self else { return }
                self.roundCorners(with: self.cornerRadius.minimised)
                self.handleCloseBackgroundAnimation()
                self.contentViewController?.didChangeState(to: .minimised)
        })
    }
    
    private func dismiss(completion: (() -> Void)? = nil) {
        state = .minimised
        setupDismissConstraints()
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                completion?()
                guard let self = self else { return }
                self.contentViewController?.didChangeState(to: .closed)
                self.destroySelf()
        })
    }
    
}

// MARK: - Scroll Animations -

extension DrawerViewController {
    private enum Direction {
        case up, down
        
        mutating func reversed() {
            switch self {
            case .up:
                self = .down
            case .down:
                self = .up
            }
        }
    }
    
    /// Initiate transition if not already running
    private func animateTransitionIfNeeded(duration: TimeInterval) {
        guard runningAnimators.isEmpty else {
            direction.reversed()
            return
        }
        switch state {
        case .fullSize:
            direction = .down
        case .minimised:
            direction = .up
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1)
        
        animator.addAnimations {
            switch self.state {
            case .fullSize:
                self.contentViewController?.willChangeState(to: .minimised)
                self.setupClosedConstraints()
                self.roundCorners(with: self.cornerRadius.minimised)
                self.handleCloseBackgroundAnimation()
            case .minimised:
                self.contentViewController?.willChangeState(to: .fullSize)
                self.setupOpenConstraints()
                self.roundCorners(with: self.cornerRadius.fullSize)
                self.handleOpenBackgroundAnimation()
            }
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch self.direction {
            case .down?:
                self.closeDrawer(animated: self.state == .minimised)
            case .up?:
                self.openDrawer(animated: self.state == .fullSize)
            default: break
            }
            
            self.direction = nil
            self.animationProgress.removeAll()
            self.runningAnimators.removeAll()
        }
        
        animator.startAnimation()
        runningAnimators.append(animator)
    }
    
    // MARK: - Show animation
    
    //initial animation to display
    private func showAnimation() {
        isInitiated = true
        switch state {
        case .fullSize:
            openDrawer()
        case .minimised:
            closeDrawer()
        }
    }
    
    
}

// MARK: - EmbeddableContentDelegate

extension DrawerViewController: EmbeddableContentDelegate {
    
    public var maxAllowedHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public func handle(embeddedAction: Drawer.EmbeddedAction) {
        
        switch embeddedAction {
        case .layoutUpdated(config: let config):
            
            if embedConfig == nil {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.embedConfig = config
                }
            }
            
        case .changeState(let drawerState):
            switch drawerState {
            case .minimise:
                contentViewController?.willChangeState(to: .minimised)
                closeDrawer()
            case .fullScreen:
                contentViewController?.willChangeState(to: .fullSize)
                openDrawer()
            case .dismiss:
                contentViewController?.willChangeState(to: .closed)
                dismiss()
            }
            
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DrawerViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let embeddedContentViewController = contentViewController else {
            return false
        }
        
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let direction = gesture.velocity(in: view).y
        
        if let scrollableContent = embeddedContentViewController as? EmbeddedScrollable {
            if state == .fullSize && scrollableContent.isScrolledToTop && direction > 0 {
                scrollableContent.setScrollEnabled(false)
            } else {
                scrollableContent.setScrollEnabled(true)
            }
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return false
        }
        
        if touch.view?.superview(of: UITableViewCell.self) != nil && gestureRecognizer is UITapGestureRecognizer {
            return false
        }
        
        return true
    }
}

// MARK: - TouchPassingWindowDelegate

extension DrawerViewController: TouchPassingWindowDelegate {
    func windowShouldBlockAll() -> Bool {
        switch backgroundInteraction {
        case .whenMinimised:
            return false
        }
    }
    
    var viewsForInterceptingTouches: [UIView] {
        guard
            let embeddedContentViewController = contentViewController
            else {
                return []
        }
        let views: [UIView] = [embeddedContentViewController.view]
        return views
    }
    
}


// MARK: - Destroy -

extension DrawerViewController {
    
    private func destroySelf() {
        contentViewController?.view.removeFromSuperview()
        contentViewController?.removeFromParent()
        
        view.removeFromSuperview()
        removeFromParent()
        
        contentViewController = nil
        backgroundViewController = nil
        embedConfig?.dismissCompleteCallback?()
        
        isInitiated = false
    }
    
}

// MARK: - DrawerBackgroundType

extension DrawerViewController {
    
    public enum DrawerBackgroundType {
        case clear
        case withColor(UIColor)
        case withBlur(UIBlurEffect.Style)
    }
    
}

// MARK: - CGFloat 2 decimal

extension DrawerViewController {
    
    func fourDecimal(_ value: CGFloat) -> CGFloat {
        return round(10000*value)/10000
    }
    
}//swiftlint:disable:this file_length

// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
