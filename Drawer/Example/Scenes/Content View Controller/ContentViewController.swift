//
//  ContentViewController.swift
//  DrawerExample
//
//  Created by Andrei Hogea on 26/02/2019.
//  Copyright (c) 2019 Andrei Hogea. All rights reserved.
//

import UIKit
import Drawer

class ContentViewController: UIViewController {
  
    // MARK: - Outlets

    var embedDelegate: EmbeddableContentDelegate?

    // MARK: - Properties
    
    // MARK: - Init
    class func instantiate() -> ContentViewController {
        let name = "\(ContentViewController.self)"
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name) as! ContentViewController
    }

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustDrawer(with: 400, with: 100)
        
        view.backgroundColor = .red
        
    }
    
    deinit {
        print("deinit content")
    }

    // MARK: - Callbacks -
    

}

extension ContentViewController: Embeddable {
    func didChangeOpenState(to state: EmbeddableState) {
        
    }
    
    func adjustDrawer(with maxHeight: CGFloat, with minHeight: CGFloat) {
        let contentConfiguration = Drawer.ContentConfiguration(embeddedFullHeight: maxHeight,
                                                               state: .fullSize,
                                                               embeddedMinimumHeight: minHeight,
                                                               dismissCompleteCallback: { [weak self] in
            print("drawer dismissed")
        })
        
        embedDelegate?.handle(embeddedAction: .layoutUpdated(config: contentConfiguration))
    }
    
    
}
