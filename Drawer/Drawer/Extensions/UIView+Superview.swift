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

extension UIView {
    
    /// Checks if a UIButton is in the Subiviews of the view directly or contained in a UIStackView
    func containsButtonsInSubviews() -> Bool {
        
        if subviews.filter({ $0 is UIButton }).count > 0 {
            return true
        } else if subviews.filter({ $0 is UIStackView }).count > 0 {
            var containsIntractable = false
            
            for stackView in subviews where stackView is UIStackView {
                let containsButton = stackView.containsButtonsInSubviews()
                containsIntractable = containsButton ? true : containsIntractable
            }
            
            return containsIntractable
        }
        
        return false
    }

    /// Checks if the touch missed a UIButton that is either in the Subiviews of the view directly or contained in a UIStackView
    func isTouchAMissedUIButtonTouch(gesture: UIGestureRecognizer) -> Bool {
        if subviews.filter({ $0 is UIButton }).count > 0 {
            return isMissedButtonTouch(gesture: gesture)
        } else if subviews.filter({ $0 is UIStackView }).count > 0 {
            var isMissedTouch = false

            for stackView in subviews where stackView is UIStackView {
                let isMissedButtonTouch = stackView.isMissedButtonTouch(gesture: gesture)
                isMissedTouch = isMissedButtonTouch ? true : isMissedTouch
            }
            
            return isMissedTouch
        } else {
            return false
        }
    }
    
    private func isMissedButtonTouch(gesture: UIGestureRecognizer) -> Bool {
        var isMissedTouch = false
        
        // allow touch if touch is not in extended Button bounds
        for button in subviews where button is UIButton {
            let touchLocation = gesture.location(in: button)

            let invalidTouchRect = CGRect(x: button.frame.minX - 10,
                                          y: button.frame.minY - 10,
                                          width: button.frame.width + 20,
                                          height: button.frame.height + 20)
            let isTouchInRect = invalidTouchRect.contains(touchLocation)
            isMissedTouch = isTouchInRect ? true : isMissedTouch
        }
        
        return isMissedTouch
        
    }
    
}
