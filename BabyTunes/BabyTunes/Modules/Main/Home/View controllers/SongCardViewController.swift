//
//  SongCardViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 25.01.18.
//  Copyright © 2018 CCDimensions. All rights reserved.
//

import AAViewAnimator
import StoreKit
import SCLAlertView

class SongCardViewController: UIViewController {
    
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var languageImage: UIImageView!
    @IBOutlet weak var shoppingView: UIView!
    
    var visualizerTimer:Timer! = Timer()
    var products: [SKProduct] = []
    
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
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showForSaleBanner), userInfo: nil, repeats: false)
 
    }

    @objc func showForSaleBanner()
    {
        if (song?.locked)!{
            shoppingView.aa_animate(duration: 1.0, springDamping: .slight, animation: animationSelection.randomElement()!)
        }
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
    
    @objc func requestAllProducts() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance).showWait("Download", subTitle: "Processing...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        
        BabyTunesProducts.store.requestProducts(language: self.song?.languageEnum ) { [unowned self] success, products in
            alert.close()
            if success,
                let products = products {
                self.products = products
                print("products : \(products)")
                self.showProductsView()
            }
            alert.close()
        }
    }
    
    @IBAction func handleTap() {
        if !(song?.locked)!{
            performSegue(withIdentifier: .reveal, sender: nil)
        }else{
             requestAllProducts()
        }
    }
    
    func showProductsView() {
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 100))
        let x = (subview.frame.width - 180) / 2
        var y = 10
        for product in products{
            // Add Pruduct for Sale
            let productForSaleView = ProductForSaleView(frame: CGRect(x: Int(x), y: y, width: 180, height: 44))
            productForSaleView.backgroundColor = UIColor.green
            y += 56
            productForSaleView.product = product
            productForSaleView.buyButtonHandler = { product in
                BabyTunesProducts.store.buyProduct(product)
            }
            subview.addSubview(productForSaleView)
        }
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        _ = alert.addButton("Login") {
            print("Logged in")
        }

        // Add Button with visible timeout and custom Colors
        let showTimeout = SCLButton.ShowTimeoutConfiguration(prefix: "(", suffix: " s)")
        _ = alert.addButton("Timeout Button", backgroundColor: UIColor.brown, textColor: UIColor.yellow, showTimeout: showTimeout) {
            print("Timeout Button tapped")
        }
        
        let timeoutValue: TimeInterval = 10.0
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
            print("Timeout occurred")
        }
        
        _ = alert.showInfo("Login", subTitle: "", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction))
    }
    
    /*
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
 */
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
