//
//  Embeddable.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Andrei Hogea. All rights reserved.
//

import Foundation
import UIKit

// A Protocol exposed to the Application
public protocol Embeddable where Self: UIViewController {
    /// Do not set this property directly. The drawer will assign it when it has finished creating.
    var embedDelegate: EmbeddableContentDelegate? { get set }
    /// Use this method to track upcoming changes in state. Triggered when Drawer state starts changing. This can be triggered by user Touch/Pan events or by calling the `embedDelegate` functions
    ///
    /// - parameters:
    ///    - state: EmbeddableState
    ///
    func willChangeState(to state: EmbeddableState)
    /// Use this method to track changes in state.
    ///
    /// - parameters:
    ///    - state: EmbeddableState
    ///
    func didChangeState(to state: EmbeddableState)
    /// Use this method to track changes of the content position.
    ///
    /// - parameters:
    ///    - progress: CGFloat (values between 0 and 1). Example: A value of 0.1 means that the user just started the transition from state, while a value of 0.9 means that the user is getting close to finishing the transition to the oposite state of the `from state`
    ///    - state: Drawer.State
    ///    - direction: DrawerViewController.Direction direction of scroll
    ///
    func didScroll(with progress: CGFloat, from state: Drawer.State)
}

public enum EmbeddableState {
    case fullSize
    case minimized
    case closed
}
