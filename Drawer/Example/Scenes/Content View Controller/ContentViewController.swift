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
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    var embedDelegate: EmbeddableContentDelegate?
    private var animationDuration: TimeInterval = 1
   
    // title animations
    private var titleAnimator: UIViewPropertyAnimator!
    private let titleScaleMax: CGFloat = 1.6

    // MARK: - Init
    
    class func instantiate() -> ContentViewController {
        let name = "\(ContentViewController.self)"
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name) as! ContentViewController
    }
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleAnimator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 1)
        titleAnimator.addAnimations {
            
        }
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
    func willChangeOpenState(to state: EmbeddableState) {
        switch state {
        case .minimised:
            titleAnimator.addAnimations {
                self.titleLabel.transform = .identity
            }
        case .fullSize:
            titleAnimator.addAnimations {
                self.titleLabel.transform = CGAffineTransform(scaleX: self.titleScaleMax, y: self.titleScaleMax).concatenating(CGAffineTransform(translationX: 8, y: 0))
            }
        default: break
        }
        
        titleAnimator.startAnimation()
    }
    
    func didChangeOpenState(to state: EmbeddableState) {
        switch state {
        case .minimised:
            collapseButton.alpha = 0
            expandButton.alpha = 1
        case .fullSize:
            collapseButton.alpha = 1
            expandButton.alpha = 0
        case .changing(let progress, let drawerState):
            switch drawerState {
            case .fullSize:
                collapseButton.alpha = 1 - progress
                expandButton.alpha = progress
                titleLabel.transform = CGAffineTransform(scaleX: titleScaleMax - (titleScaleMax - 1)*progress,
                                                         y: titleScaleMax - (titleScaleMax - 1)*progress).concatenating(CGAffineTransform(translationX: 8 - 8*progress, y: 0))
            case .minimised:
                collapseButton.alpha = progress
                expandButton.alpha = 1 - progress
                titleLabel.transform = CGAffineTransform(scaleX: 1 + (titleScaleMax - 1)*progress,
                                                         y: 1 + (titleScaleMax - 1)*progress).concatenating(CGAffineTransform(translationX: 8*progress, y: 0))
            }
        case .closed:
            break
        }
    }
    
    func adjustDrawer(with maxHeight: CGFloat, with minHeight: CGFloat) {
        let contentConfiguration = Drawer.ContentConfiguration(duration: animationDuration,
                                                               embeddedFullHeight: maxHeight,
                                                               state: .minimised,
                                                               embeddedMinimumHeight: minHeight,
                                                               dismissCompleteCallback:
            { [weak self] in
                guard let self = self else { return }
                //TODO: Drawer dismissed.
        })
        
        embedDelegate?.handle(embeddedAction: .layoutUpdated(config: contentConfiguration))
    }
    
    
}
