//
//  TouchInterceptingView.swift
//  Drawer
//
//  Created by Jakob Mygind Jensen on 07/02/2018.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

protocol TouchPassingWindowDelegate: class {
    func windowShouldBlockAll() -> Bool
    var viewsForInterceptingTouches: [UIView] { get }
}

class TouchInterceptingView: UIView {
    
    weak var delegate: TouchPassingWindowDelegate?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if delegate?.windowShouldBlockAll() == true {
            return self
        }
        
        var isDescendant = false
        if let hitView = hitView, let interceptList = delegate?.viewsForInterceptingTouches {
            for v in interceptList {
                if hitView.isDescendant(of: v) {
                    isDescendant = true
                }
            }
            
            if delegate?.viewsForInterceptingTouches.contains(hitView) == true || isDescendant {
                return hitView
            }
        }
        
        return nil
    }
    
}
