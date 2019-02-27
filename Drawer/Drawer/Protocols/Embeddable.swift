//
//  Embeddable.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Andrei Hogea. All rights reserved.
//

import Foundation
import UIKit

protocol Embeddable where Self: UIViewController {
    var embedDelegate: EmbeddableContentDelegate? { get set }
    func didChangeOpenState(to state: EmbeddableState)
    func adjustDrawer(with maxHeight: CGFloat, with minHeight: CGFloat)
}

enum EmbeddableState {
    case fullScreen
    case changing(progress: CGFloat, state: Drawer.State)
    case miniScreen
    case closed
}
