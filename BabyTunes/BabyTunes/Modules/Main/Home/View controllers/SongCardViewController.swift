//
//  SongCardViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 25.01.18.
//  Copyright © 2018 CCDimensions. All rights reserved.
//


class SongCardViewController: UIViewController {
    
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var languageImage: UIImageView!
    
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
        cardView.backgroundColor = cardSong.languageEnum.languageTintColor()
        
        imageView.image = UIImage(named: cardSong.title + ".jpg")
        imageView.layer.cornerRadius = 15
        languageImage.image = cardSong.languageEnum.languageMouseCharacterIconImage()
        languageLabel.text = cardSong.languageEnum.languageName()
        languageLabel.textColor = UIColor.orange
        
        imageView.layer.masksToBounds = false;
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueIdentifier(for: segue) == .reveal,
            let destinationViewController = segue.destination as? RevealViewController {
            destinationViewController.song = song
            
            destinationViewController.transitioningDelegate = self
        }
    }
    
    @IBAction func handleTap() {
        performSegue(withIdentifier: .reveal, sender: nil)
    }
    
}

extension SongCardViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case reveal
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
            guard let revealVC = dismissed as? RevealViewController else {
                return nil
            }
            return FlipDismissAnimationController(destinationFrame: cardView.frame,
                                                  interactionController: revealVC.swipeInteractionController)
    }
}


