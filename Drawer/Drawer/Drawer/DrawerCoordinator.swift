//
//  DrawerCoordinator.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import Foundation
import UIKit

public class DrawerCoordinator {
    
    private let backgroundViewController: UIViewController
    private let contentViewController: (UIViewController & Embeddable)
    private let drawerBackgroundType: DrawerViewController.DrawerBackgroundType
    private let cornerRadius: CGFloat
    
    public init(contentViewController: UIViewController & Embeddable,
         backgroundViewController: UIViewController,
         drawerBackgroundType: DrawerViewController.DrawerBackgroundType,
         with cornerRadius: CGFloat? = 0) {
        self.contentViewController = contentViewController
        self.backgroundViewController = backgroundViewController
        self.drawerBackgroundType = drawerBackgroundType
        self.cornerRadius = cornerRadius ?? 0
    }
    
    public func start() {
        if backgroundViewController.children.contains(where: { $0 is DrawerViewController }) {
            assertionFailure("\(backgroundViewController) already contains a Drawer. Multiple drawers not supported.")
            return
        }
        
        let drawerVC = DrawerViewController()
        drawerVC.contentViewController = contentViewController
        drawerVC.backgroundViewController = backgroundViewController
        
        drawerVC.makeViews(with: drawerBackgroundType, with: cornerRadius)
    }

}
