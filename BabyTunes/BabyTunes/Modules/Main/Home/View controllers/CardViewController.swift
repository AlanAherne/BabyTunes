
import UIKit
import AVFoundation

class CardViewController: UIViewController {
  
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var languageImage: UIImageView!
    
    var pageIndex: Int?
    var song: Song?
    static var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let cardSong = song else {
            NSLog("no song set in the card view controller")
            return
        }
        
        titleLabel.text = cardSong.title
        titleLabel.font = UIFont.songTitleFont()
        cardView.layer.cornerRadius = CardViewController.cardCornerRadius
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = cardSong.languageEnum.languageTintColor()
        
        imageView.image = UIImage(named: (cardSong.title)! + ".jpg")
        imageView.layer.cornerRadius = CardViewController.cardCornerRadius
        languageImage.image = cardSong.languageEnum.languageMouseCharacterIconImage()
        
        imageView.layer.masksToBounds = false;
        imageView.layer.cornerRadius = CardViewController.cardCornerRadius;
        imageView.layer.shadowOffset = CGSize(width: 5, height: 5);
        imageView.layer.shadowRadius = 5;
        imageView.layer.shadowOpacity = 0.8
        
        initEmitter()
        initAudioPlayer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setToPlay(notification:)), name: .playBGMusic, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setToPause(notfication:)), name: .pauseBGMusic, object: nil)
    }

    @objc func setToPlay(notification: NSNotification) {
        CardViewController.audioPlayer.play()
    }
    @objc func setToPause(notfication: NSNotification) {
        CardViewController.audioPlayer.pause()
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
    
    func initAudioPlayer() {
        if CardViewController.audioPlayer == nil{
            let urlpath = Bundle.main.path(forResource: "bgmusic", ofType: "mp3")
            let url = URL(fileURLWithPath: urlpath!)
            let _: NSError?
            do {
                CardViewController.audioPlayer = try AVAudioPlayer(contentsOf: url)
            }
            catch let error {
                print(error)
            }
            CardViewController.audioPlayer.isMeteringEnabled = true
            CardViewController.audioPlayer.prepareToPlay()
            CardViewController.audioPlayer.numberOfLoops = -1
            CardViewController.audioPlayer.volume = 0.4
            CardViewController.audioPlayer.play()
        }
    }
    
    // Wird aufgerufen um den Schneeflocken-Emitter zu initialisieren
    func initEmitter(){
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.size.width * 0.5, y: -50.0)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        emitterLayer.emitterSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1.0)
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.scale = 0.5; // 7
        emitterCell.scaleRange = 0.5; // 8
        emitterCell.emissionRange = CGFloat(Double.pi); // 9
        emitterCell.lifetime = 10.0; // 10
        emitterCell.birthRate = 2; // 11
        emitterCell.velocity = 0; // 12
        emitterCell.velocityRange = 0; // 13
        emitterCell.yAcceleration = 30; // 14
        emitterCell.spin = 0
        emitterCell.spinRange = 2.0
        let img = UIImage(named: "Note")
        emitterCell.contents = img?.cgImage as AnyObject
        
        let emitterCellBlur = CAEmitterCell()
        emitterCellBlur.scale = 1.5; // 7
        emitterCellBlur.scaleRange = 0.5; // 8
        emitterCellBlur.emissionRange = CGFloat(Double.pi); // 9
        emitterCellBlur.lifetime = 15.0; // 10
        emitterCellBlur.birthRate = 1; // 11
        emitterCellBlur.velocity = 0; // 12
        emitterCellBlur.velocityRange = 0; // 13
        emitterCellBlur.yAcceleration = 20; // 14
        emitterCellBlur.spin = 0
        emitterCellBlur.spinRange = 2.0
        emitterCellBlur.contents = UIImage(named: "NoteBlur")!.cgImage as AnyObject
        emitterCellBlur.alphaRange = 0.7
        emitterLayer.emitterCells = [emitterCell,emitterCellBlur]
        //view.layer.addSublayer(emitterLayer)
        view.layer.insertSublayer(emitterLayer, at: 0)
    }
}

extension CardViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case reveal
    }
}


extension CardViewController: UIViewControllerTransitioningDelegate {
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

