//
//  SongCardViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 25.01.18.
//  Copyright © 2018 CCDimensions. All rights reserved.
//

import AAViewAnimator

class SongCardViewController: UIViewController {
    
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var languageImage: UIImageView!
    @IBOutlet weak var shoppingView: UIView!
    @IBOutlet weak var appStoreView: UIView!
    
    let animationSelection: [AAViewAnimators] = [.fromTop, .fromBottom, .fromLeft, .fromRight, .fromFade]
    let animationTransition: [AAViewAnimators] = [.scale(rate:1.2), .vibrateX(rate: 5), .vibrateY(rate: 5), .rotateLeft, .rotateRight, .rotateRound]
    
    var pageIndex: Int?
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let cardSong = song else {
            NSLog("no song set in the card view controller")
            return
        }
        
        titleLabel.text = cardSong.title
        titleLabel.font = UIFont.songTitleFont()
        
        cardView.layer.cornerRadius = 15
        cardView.layer.masksToBounds = true
        
        imageView.image = UIImage(named: cardSong.title + ".jpg")
        imageView.layer.cornerRadius = 15
        
        languageImage.image = cardSong.languageEnum.languageMouseCharacterIconImage()
        languageLabel.text = cardSong.languageEnum.languageName()
        languageLabel.textColor = UIColor.orange
        
        imageView.layer.masksToBounds = false;
        imageView.layer.cornerRadius = 15
        
        shoppingView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingView.aa_animate(duration: 0.1, springDamping: .none, animation: .toFade)
        appStoreView.aa_animate(duration: 0.1, springDamping: .none, animation: .toFade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueIdentifier(for: segue) == .reveal,
            let destinationViewController = segue.destination as? RevealViewController {
            destinationViewController.song = song
            
            destinationViewController.transitioningDelegate = self
        }
        else if segueIdentifier(for: segue) == .login,
            let destinationViewController = segue.destination as? LoginViewController {
            destinationViewController.transitioningDelegate = self
        }
 
    }
    
    @IBAction func handleTap() {
        if (song?.locked)!{
          animateWithTransition(animationSelection.randomElement()!, animationTransition.randomElement()!)
        }else{
            performSegue(withIdentifier: .reveal, sender: nil)
        }
    }
    
    func animateWithTransition(_ animator: AAViewAnimators, _ transition: AAViewAnimators) {
        shoppingView.aa_animate(duration: 1.0, springDamping: .slight, animation: animator) { [appStoreView] inAnimating in
            if inAnimating {
                print("Animating .... with : \(animator)")
            }
            else {
                appStoreView?.aa_animate(duration: 1.5, springDamping: .heavy, animation: .fromTop) { inAnimating in
                    if inAnimating {
                        print("Animating .... with : \(animator)")
                    }
                }
            }
        }
    }
}

extension SongCardViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case reveal
        case shop
        case login
    }
}


extension SongCardViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: cardView.frame)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            if let revealVC = dismissed as? RevealViewController {
                return FlipDismissAnimationController(destinationFrame: cardView.frame,
                                                      interactionController: revealVC.swipeInteractionController)
            }else if let loginVC = dismissed as? LoginViewController{
                return FlipDismissAnimationController(destinationFrame: cardView.frame,
                                                      interactionController: loginVC.swipeInteractionController)
            }
            return nil
    }
}


