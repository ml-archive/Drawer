//
//  BottomDrawerProtocols.swift
//  Listen-to-News
//
//  Created by Andrei Hogea on 06/08/2018.
//  Copyright © 2019 Nodes. All rights reserved.
//

import Foundation
import UIKit

// ======== Coordinator ======== //

//protocol BottomDrawerCoordinatorDelegate: class {
//    func coordinator(_ coordinator: Coordinator, finishedWithSuccess success: Bool)
//}

// PRESENTER -> COORDINATOR
protocol BottomDrawerCoordinatorInput: class {

}

// ======== Presenter ======== //

// VIEW -> PRESENTER
protocol BottomDrawerPresenterInput {
    func viewCreated()
}

// PRESENTER -> VIEW
protocol BottomDrawerPresenterOutput: class {
    // func display(_ displayModel: BottomDrawer.DisplayData.Work)
}

protocol EmbeddableContentDelegate: class {
    func handleEmbeddedContentAction(_ action: BottomDrawer.EmbeddedAction)
    var maxAllowedHeight: CGFloat { get }
}

// MARK: - Public Protocols

protocol EmbeddedScrollable: Embeddable {
    var isScrolledToTop: Bool { get }
    func setScrollEnabled(_ enabled: Bool)
}

protocol Embeddable where Self: UIViewController {
    var embedDelegate: EmbeddableContentDelegate? { get set }
    func didChangeOpenState(to state: EmbeddableOpenState)
    func adjustDrawer(with maxHeight: CGFloat, with minHeight: CGFloat) 
}
