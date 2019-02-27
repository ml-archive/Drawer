//
//  EmbeddableContentDelegate.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import Foundation
import UIKit

public protocol EmbeddableContentDelegate: class {
    func handle(embeddedAction: Drawer.EmbeddedAction)
    var maxAllowedHeight: CGFloat { get }
}


