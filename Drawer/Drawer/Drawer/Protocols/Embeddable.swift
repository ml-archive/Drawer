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
    /// Use this method to track upcoming changes in state. Triggered by user tap events or changing of the state caused by calling of the `EmbeddableContentDelegate` handle action
    ///
    /// - parameters:
    ///    - state: EmbeddableState
    ///
    func willChangeOpenState(to state: EmbeddableState)
    /// Use this method to track scroll progress and changes in state.
    ///
    /// - parameters:
    ///    - state: EmbeddableState
    ///
    func didChangeOpenState(to state: EmbeddableState)
    /// Use this method to adjust the drawer state. Call this method whenever your Content UIViewController has finished laying out its subviews or has changed its subviews.
    ///
    /// - parameters:
    ///    - maxHeight: Maximum allowed height. A value of 300 will allow the Drawer to expand 300 points from the bottom
    ///    - minHeight: Minumum allowed height. A value of 100 will allow the Drawer to collapse to 100 points from the bottom
    ///
    func adjustDrawer(with maxHeight: CGFloat, with minHeight: CGFloat)
}

public enum EmbeddableState {
    case fullSize
    case changing(progress: CGFloat, state: Drawer.State)
    case minimised
    case closed
}
