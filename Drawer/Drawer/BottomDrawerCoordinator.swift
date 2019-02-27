//
//  BottomDrawerCoordinator.swift
//  Listen-to-News
//
//  Created by Andrei Hogea on 06/08/2018.
//  Copyright © 2019 Nodes. All rights reserved.
//

import Foundation
import UIKit

class BottomDrawerCoordinator {
    
    private let backgroundViewController: UIViewController
    private let contentViewController: (UIViewController & Embeddable)
    private let drawerBackgroundType: BottomDrawerViewController.DrawerBackgroundType
    private let cornerRadius: CGFloat
    
    init(contentViewController: UIViewController & Embeddable,
         backgroundViewController: UIViewController,
         drawerBackgroundType: BottomDrawerViewController.DrawerBackgroundType,
         with cornerRadius: CGFloat? = 0) {
        self.contentViewController = contentViewController
        self.backgroundViewController = backgroundViewController
        self.drawerBackgroundType = drawerBackgroundType
        self.cornerRadius = cornerRadius ?? 0
    }
    
    func start() {
        if backgroundViewController.children.contains(where: { $0 is BottomDrawerViewController }) {
            assertionFailure("\(backgroundViewController) already contains a Drawer. Multiple drawers not supported.")
            return
        }
        
        let drawerVC = BottomDrawerViewController.instantiate()
        drawerVC.contentViewController = contentViewController
        drawerVC.backgroundViewController = backgroundViewController
        
        drawerVC.makeViews(with: drawerBackgroundType, with: cornerRadius)
    }

}


// PRESENTER -> COORDINATOR
extension BottomDrawerCoordinator: BottomDrawerCoordinatorInput {
    
}
