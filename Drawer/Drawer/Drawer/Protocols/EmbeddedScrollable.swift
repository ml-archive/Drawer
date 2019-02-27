//
//  EmbeddedScrollable.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Andrei Hogea. All rights reserved.
//

import Foundation

// A Protocol exposed to the Application
public protocol EmbeddedScrollable: Embeddable {
    /// Use this parameter to tell the drawer if the content UIViewContoller's embeded UIScrollView is scrolled to top.
    ///
    /// - parameters:
    ///    - enabled: Bool
    ///
    var isScrolledToTop: Bool { get }
    /// Use this method to determine if the content UIViewContoller's embeded UIScrollView should allow scrolling.
    ///
    /// - parameters:
    ///    - enabled: Bool
    ///
    func setScrollEnabled(_ enabled: Bool)
}
