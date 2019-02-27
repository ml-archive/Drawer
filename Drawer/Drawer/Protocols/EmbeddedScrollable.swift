//
//  EmbeddedScrollable.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Andrei Hogea. All rights reserved.
//

import Foundation

// A Protocol exposed to the Application
protocol EmbeddedScrollable: Embeddable {
    var isScrolledToTop: Bool { get }
    func setScrollEnabled(_ enabled: Bool)
}
