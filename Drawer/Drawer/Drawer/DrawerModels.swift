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

    public struct ContentConfiguration {
        let duration: TimeInterval
        let embeddedFullHeight: CGFloat
        let embeddedMinimumHeight: CGFloat
        let state: Drawer.State
        let cornerRadius: ContentConfiguration.CornerRadius
        let dismissCompleteCallback: (() -> Void)?
        
        public init(duration: TimeInterval,
                    embeddedFullHeight: CGFloat,
                    state: Drawer.State,
                    embeddedMinimumHeight: CGFloat,
                    cornerRadius: ContentConfiguration.CornerRadius? = nil,
                    dismissCompleteCallback: (() -> Void)? = nil) {
            self.duration = duration
            self.embeddedMinimumHeight = embeddedMinimumHeight
            self.embeddedFullHeight = embeddedFullHeight
            self.state = state
            self.cornerRadius = cornerRadius ?? CornerRadius(fullSize: 0, minimised: 0)
            self.dismissCompleteCallback = dismissCompleteCallback
        }
        
        public struct CornerRadius {
            let fullSize: CGFloat
            let minimised: CGFloat
            
            public init(fullSize: CGFloat, minimised: CGFloat) {
                self.fullSize = fullSize
                self.minimised = minimised
            }
        }
    }
    
}
