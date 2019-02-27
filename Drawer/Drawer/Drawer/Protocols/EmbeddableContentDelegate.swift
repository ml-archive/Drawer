//
//  EmbeddableContentDelegate.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import Foundation
import UIKit

protocol EmbeddableContentDelegate: class {
    func handleEmbeddedContentAction(_ action: Drawer.EmbeddedAction)
    var maxAllowedHeight: CGFloat { get }
}


