//
//  BottomDrawerModels.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

enum Drawer {
    
    enum State: Int {
        case fullSize
        case minimised
    }
    
    enum ContainerInteraction: Int {
        case whenMinimised
    }
    
    enum EmbeddedAction {
        case layoutUpdated(config: Drawer.ContentConfiguration)
        case animateOverlay(isHidden: Bool)
        case changeState(to: MovementState)
        
        enum MovementState: Int {
            case minimise
            case fullScreen
            case dismiss
        }
    }

    enum Status: Int {
        case open
        case closed
    }
    
    struct ContentConfiguration {
        let embeddedFullHeight: CGFloat
        let embeddedMinimumHeight: CGFloat
        let state: Drawer.State
        let dismissCompleteCallback: (() -> Void)?
        
        init(embeddedFullHeight: CGFloat,
             state: Drawer.State,
             embeddedMinimumHeight: CGFloat,
             dismissCompleteCallback: (() -> Void)? = nil) {
            self.embeddedMinimumHeight = embeddedMinimumHeight
            self.embeddedFullHeight = embeddedFullHeight
            self.state = state
            self.dismissCompleteCallback = dismissCompleteCallback
        }
    }
    
}
