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
        case minimized
    }
    
    internal enum ContainerInteraction: Int {
        case whenMinimised
    }
    
    public enum Action {
        case layoutUpdated(config: Drawer.Configuration)
        case changeState(to: MovementState)
        
        public enum MovementState: Int {
            case minimize
            case fullScreen
            case dismiss
        }
    }

    public struct Configuration {

        let duration: TimeInterval
        let embeddedFullHeight: CGFloat
        let embeddedMinimumHeight: CGFloat
        let state: Drawer.State
        let cornerRadius: Configuration.CornerRadius
        let dismissCompleteCallback: (() -> Void)?

        /**
         Creates a Configuration for the Drawer

         - Parameter options: Use options to configure the Drawer.
         - Parameter dismissCompleteCallback: Called when the Drawer has finished dismissing

         Available configurations:
         - .animationDuration: TimeInterval
         -- default value is 0.3

         - .fullHeight: CGFloat
         -- default value is 300

         - .minimumHeight: CGFloat
         -- default value is 100

         - .initialState: Drawer.State
         -- default value is .minimized

         - .cornerRadius: ContentConfiguration.CornerRadius
         -- default value is CornerRadius(fullSize: 0, minimized: 0)

         */
        public init(options: [Drawer.Configuration.Key: Any],
                    dismissCompleteCallback: (() -> Void)? = nil) {
            
            duration = options[.animationDuration] as? TimeInterval ?? 0.3
            embeddedFullHeight = options[.fullHeight] as? CGFloat ?? 300
            embeddedMinimumHeight = options[.minimumHeight] as? CGFloat ?? 100
            state = options[.initialState] as? Drawer.State  ?? .minimized
            cornerRadius = options[.cornerRadius] as? Configuration.CornerRadius ?? Configuration.CornerRadius(fullSize: 0, minimized: 0)
            
            
            self.dismissCompleteCallback = dismissCompleteCallback
        }
        
        public enum Key: String, CaseIterable {
            case animationDuration
            case fullHeight
            case minimumHeight
            case initialState
            case cornerRadius
        }
        
        public struct CornerRadius {
            let fullSize: CGFloat
            let minimized: CGFloat
            
            public init(fullSize: CGFloat, minimized: CGFloat) {
                self.fullSize = fullSize
                self.minimized = minimized
            }
        }
    }
    
}
