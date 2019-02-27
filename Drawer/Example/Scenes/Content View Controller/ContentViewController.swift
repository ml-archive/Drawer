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
    
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var collapseButton: UIButton!
    
    // MARK: - Properties
    
    var embedDelegate: EmbeddableContentDelegate?
    
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

    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowOpacity = 0.3
        view.clipsToBounds = false
        view.layer.masksToBounds = false
    }
    
    // MARK: - Callbacks -
    
    @IBAction func expactTapped(_ sender: Any) {
        embedDelegate?.handle(embeddedAction: .changeState(to: .fullScreen))
    }
    
    @IBAction func collapseTapped(_ sender: Any) {
        embedDelegate?.handle(embeddedAction: .changeState(to: .minimise))
    }
    
}

extension ContentViewController: Embeddable {
    func didChangeOpenState(to state: EmbeddableState) {
        switch state {
        case .miniScreen:
            collapseButton.alpha = 0
            expandButton.alpha = 1
        case .fullScreen:
            collapseButton.alpha = 1
            expandButton.alpha = 0
        case .changing(let progress, let drawerState):
            switch drawerState {
            case .fullSize:
                collapseButton.alpha = 1 - progress
                expandButton.alpha = progress
            case .minimised:
                collapseButton.alpha = progress
                expandButton.alpha = 1 - progress
            }
        case .closed:
            break
        }
    }
    
    func adjustDrawer(with maxHeight: CGFloat, with minHeight: CGFloat) {
        let contentConfiguration = Drawer.ContentConfiguration(embeddedFullHeight: maxHeight,
                                                               state: .fullSize,
                                                               embeddedMinimumHeight: minHeight,
                                                               dismissCompleteCallback:
            { [weak self] in
                guard let self = self else { return }
                //TODO: Drawer dismissed.
        })
        
        embedDelegate?.handle(embeddedAction: .layoutUpdated(config: contentConfiguration))
    }
    
    
}
