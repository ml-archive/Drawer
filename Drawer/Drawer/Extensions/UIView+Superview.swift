//
//  UIView+Superview.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
    
}
