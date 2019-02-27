//
//  BottomDrawerModels.swift
//  Drawer
//
//  Created by Andrei Hogea on 27/02/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

public enum Drawer {
    
    public enum State: Int {
        case fullSize
        case minimised
    }
    
    internal enum ContainerInteraction: Int {
        case whenMinimised
    }
    
    public enum EmbeddedAction {
        case layoutUpdated(config: Drawer.ContentConfiguration)
        case changeState(to: MovementState)
        
        public enum MovementState: Int {
            case minimise
            case fullScreen
            case dismiss
        }
    }

    internal enum Status: Int {
        case open
        case closed
    }
    
    public struct ContentConfiguration {
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