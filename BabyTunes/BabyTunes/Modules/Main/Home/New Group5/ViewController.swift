import UIKit
import CoreMotion
import AVFoundation
import SpriteKit

class ViewController: UIViewController {
    var motionManager: CMMotionManager!
    //var lock: Bool = false
    var imgView: UIImageView!
    var infoLabel: UILabel!
    //var players = NSMutableArray()
    //var bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell1", ofType: "wav")!)
    var interfaceNumber: Int = 0
    var soundManager: SoundManager?
    var soundNotes = Array<UInt32>()
    var lastXAcceleration: Double = 0
    var bellLock: Bool = false
    
    // Wird aufgerufen, wenn der View geladen wurde
    override func viewDidLoad() {
        super.viewDidLoad()
        initEmitter()
        
        soundManager = SoundManager()
        // Sound
        //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        //AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        
        // Image View
        imgView = UIImageView()
        imgView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(imgView)
        view.addConstraint(NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil , attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 200.0))
        view.addConstraint(NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil , attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 267.0))

        
        // Info Label
        infoLabel = UILabel()
        infoLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.textColor = UIColor(red: CGFloat(0xEF/255.0), green: CGFloat(0xEF/255.0), blue: CGFloat(0xEF/255.0), alpha: 1.0)
        infoLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        infoLabel.numberOfLines = 0
        infoLabel.text = NSLocalizedString("InfoText", comment: "")
        view.addSubview(infoLabel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[infoLabel]-10-|", options: nil, metrics: nil, views: ["infoLabel":infoLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[infoLabel(60)]-10-|", options: nil, metrics: nil, views: ["infoLabel":infoLabel]))
        
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
            (data, error) in
            let absAcc = fabs(data.acceleration.x)
            if (absAcc < self.lastXAcceleration && self.lastXAcceleration > 2.0 && !self.bellLock){
                self.bellLock = true
                for note in self.soundNotes{
                    var velocity = self.lastXAcceleration * 40
                    velocity = velocity > 127 ? 127 : velocity
                    self.soundManager!.playNoteOn(note, velocity: UInt32(velocity))
                }
            }
            if (absAcc < 1.0 && self.bellLock){
                self.bellLock = false
            }
            self.lastXAcceleration = absAcc
            /*if (fabs(data.acceleration.x) > 2.0 && !self.lock){
                self.lock = true
                var error:NSError?
                let audio = AVAudioPlayer(contentsOfURL: self.bellSound, error: &error)
                audio.prepareToPlay()
                audio.play()
                self.players.addObject(audio)
                var deletePlayers = Array<AVAudioPlayer>()
                for var idx = 0; idx < self.players.count; ++idx{
                    let p = self.players[idx] as AVAudioPlayer
                    if (!p.playing){
                        deletePlayers.append(p)
                    }
                }
                for p in deletePlayers{
                    self.players.removeObject(p)
                }
            }

            else if (fabs(data.acceleration.x) < 0.5 && self.lock){
                self.lock = false
            }*/
        }
        
        
        
        // Gesture-Recognizers
        var leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        leftSwipe.addTarget(self, action: Selector("leftSwipeDetected"))
        view.addGestureRecognizer(leftSwipe)

        var rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        rightSwipe.addTarget(self, action: Selector("rightSwipeDetected"))
        view.addGestureRecognizer(rightSwipe)
        
        updateInterfaceAnimated(false)
    }
    
    
    
    // Wird aufgerufen um den Schneeflocken-Emitter zu initialisieren
    func initEmitter(){
        var emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.size.width * 0.5, y: -50.0)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        emitterLayer.emitterSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 1.0)
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.scale = 0.5; // 7
        emitterCell.scaleRange = 0.5; // 8
        emitterCell.emissionRange = CGFloat(M_PI); // 9
        emitterCell.lifetime = 10.0; // 10
        emitterCell.birthRate = 2; // 11
        emitterCell.velocity = 0; // 12
        emitterCell.velocityRange = 0; // 13
        emitterCell.yAcceleration = 30; // 14
        emitterCell.spin = 0
        emitterCell.spinRange = 2.0
        emitterCell.contents = UIImage(named: "Snowflake")!.CGImage as AnyObject
        
        let emitterCellBlur = CAEmitterCell()
        emitterCellBlur.scale = 1.5; // 7
        emitterCellBlur.scaleRange = 0.5; // 8
        emitterCellBlur.emissionRange = CGFloat(M_PI); // 9
        emitterCellBlur.lifetime = 15.0; // 10
        emitterCellBlur.birthRate = 1; // 11
        emitterCellBlur.velocity = 0; // 12
        emitterCellBlur.velocityRange = 0; // 13
        emitterCellBlur.yAcceleration = 20; // 14
        emitterCellBlur.spin = 0
        emitterCellBlur.spinRange = 2.0
        emitterCellBlur.contents = UIImage(named: "SnowflakeBlur")!.CGImage as AnyObject
        emitterCellBlur.alphaRange = 0.7
        emitterLayer.emitterCells = [emitterCell,emitterCellBlur]
        view.layer.addSublayer(emitterLayer)
    }
    
    
    
    // MARK: Gesture-Recognizers
    
    // Left-Swiper detected
    func leftSwipeDetected(){
        interfaceNumber = ++interfaceNumber % 5
        updateInterfaceAnimated(true)
    }
    
    // Right-Swipe detected
    func rightSwipeDetected(){
        if (interfaceNumber == 0){
            interfaceNumber = 4
        }
        else{
            --interfaceNumber
        }
        updateInterfaceAnimated(true)
    }
    
    
    
    // MARK: Helper-Funktionen
    
    // Wird aufgerufen, wenn das Interface geändert werden soll
    func updateInterfaceAnimated(animated: Bool){
        /*for var idx = 0; idx < players.count; ++idx{
            (players[idx] as AVAudioPlayer).stop()
        }*/
        //players.removeAllObjects()
        var backroundColor: UIColor
        var bellImage: UIImage
        switch(interfaceNumber){
        case 0:
            backroundColor = UIColor(red: CGFloat(0xE2)/255.0, green: CGFloat(0x50)/255.0, blue: CGFloat(0x41)/255.0, alpha: 1.0)
            bellImage = UIImage(named: "bell1")!
            soundNotes = [60]
            //bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell1", ofType: "wav")!)
        case 1:
            backroundColor = UIColor(red: CGFloat(0x1A)/255.0, green: CGFloat(0xBC)/255.0, blue: CGFloat(0x9C)/255.0, alpha: 1.0)
            bellImage = UIImage(named: "bell2")!
            soundNotes = [90]
            //bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell2", ofType: "wav")!)
        case 2:
            backroundColor = UIColor(red: CGFloat(0x2C)/255.0, green: CGFloat(0x82)/255.0, blue: CGFloat(0xC9)/255.0, alpha: 1.0)
            bellImage = UIImage(named: "bell3")!
            soundNotes = [70]
            //bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell3", ofType: "wav")!)
        case 3:
            backroundColor = UIColor(red: CGFloat(0x93)/255.0, green: CGFloat(0x65)/255.0, blue: CGFloat(0xB8)/255.0, alpha: 1.0)
            bellImage = UIImage(named: "bell4")!
            soundNotes = [50]
            //bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell4", ofType: "wav")!)
        case 4:
            backroundColor = UIColor(red: CGFloat(0xF3)/255.0, green: CGFloat(0x79)/255.0, blue: CGFloat(0x34)/255.0, alpha: 1.0)
            bellImage = UIImage(named: "bell5")!
            soundNotes = [30]
            //bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell5", ofType: "wav")!)
        default:
            backroundColor = UIColor(red: CGFloat(0xE2)/255.0, green: CGFloat(0x50)/255.0, blue: CGFloat(0x41)/255.0, alpha: 1.0)
            bellImage = UIImage(named: "bell6")!
            soundNotes = [75,77,79]
            //bellSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bell1", ofType: "wav")!)
        }
        if (animated){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.backgroundColor = backroundColor
                self.imgView.alpha = 0.0
            }, completion: { (success) -> Void in
                self.imgView.image = bellImage
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.imgView.alpha = 1.0
                })
            })
            
        }
        else{
            imgView.image = bellImage
            view.backgroundColor = backroundColor
        }
    }
}

