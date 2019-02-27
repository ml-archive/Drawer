//
//  BottomDrawerModels.swift
//  Listen-to-News
//
//  Created by Andrei Hogea on 06/08/2018.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

enum BottomDrawer {
    
    enum DrawerState {
        case fullSize
        case minimised
    }
    
    enum DrawerContainerInteraction {
        case always
        case whenMinimised
        case never
    }
    
    enum EmbeddedAction {
        case layoutUpdated(config: BottomDrawer.EmbeddableContentConfig)
        case animateOverlay(isHidden: Bool)
        case changeState(to: DrawerMovementState)
        
        enum DrawerMovementState {
            case minimise
            case fullScreen
            case dismiss
        }
    }

    struct EmbeddableContentConfig {
        let embeddedFullHeight: CGFloat
        let embeddedMinimumHeight: CGFloat
        let state: BottomDrawer.DrawerState
        let backgroundInteraction: DrawerContainerInteraction
        let dismissCompleteCallback: (() -> Void)?
        
        init(embeddedFullHeight: CGFloat,
             state: BottomDrawer.DrawerState,
             embeddedMinimumHeight: CGFloat,
             backgroundInteraction: DrawerContainerInteraction,
             dismissCompleteCallback: (() -> Void)? = nil) {
            self.embeddedMinimumHeight = embeddedMinimumHeight
            self.embeddedFullHeight = embeddedFullHeight
            self.state = state
            self.dismissCompleteCallback = dismissCompleteCallback
            self.backgroundInteraction = backgroundInteraction
        }
    }
    
    enum Status: Int {
        case open
        case closed
    }
}

enum EmbeddableOpenState {
    case fullScreen
    case changing(progress: CGFloat, state: BottomDrawer.DrawerState)
    case miniScreen
    case closed
}
