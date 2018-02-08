
import UIKit
import AVFoundation

class MainViewController: UIViewController {
  
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var checkBox1: Checkbox!
    @IBOutlet weak var checkBox2: Checkbox!
    @IBOutlet weak var checkBox3: Checkbox!
    @IBOutlet weak var checkBox4: Checkbox!
    var pagingController :PageViewController?
    var activeLangauges = Set<Int>()
    static var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activeLangauges = pagingController!.activeLangauges
        checkBox1.tag = Language.england.rawValue
        checkBox2.tag = Language.germany.rawValue
        checkBox3.tag = Language.spain.rawValue
        checkBox4.tag = Language.france.rawValue
        designCheckBox(checkBox1)
        designCheckBox(checkBox2)
        designCheckBox(checkBox3)
        designCheckBox(checkBox4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setToPlay(notification:)), name: .playBGMusic, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setToPause(notfication:)), name: .pauseBGMusic, object: nil)
        
        initAudioPlayer()
        initEmitter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let pvc = segue.destination as? PageViewController {
            self.pagingController = pvc
        }
    }
    
    func designCheckBox(_ checkBox: Checkbox){
        checkBox.borderStyle = .circle
        checkBox.checkmarkStyle = .circle
        checkBox.borderWidth = 6
        checkBox.uncheckedBorderColor = .lightGray
        checkBox.checkedBorderColor = .black
        checkBox.checkmarkSize = 0.4
        checkBox.checkmarkColor = UIColor.orange
        checkBox.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        checkBox.isChecked = self.activeLangauges.contains(checkBox.tag)
    }
    
    // target action example
    @objc func circleBoxValueChanged(sender: Checkbox) {
        if !sender.isChecked && activeLangauges.count == 1{
            sender.isChecked = true
            return
        }
        if let index = activeLangauges.index(of:sender.tag) {
            activeLangauges.remove(at: index)
        }else{
            activeLangauges.insert(sender.tag)
        }
        
        guard let pvc = self.pagingController else{
            NSLog("Paging View Controller not ready")
            return
        }
        UserDefaults.standard.set(sender.isChecked, forKey: (Language(rawValue: sender.tag)?.languageName())!)
        pvc.updateActiveLangauges(updatedActiveLanguages: self.activeLangauges)
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
        view.layer.insertSublayer(emitterLayer, at: 0)
    }
    
    func initAudioPlayer() {
        if MainViewController.audioPlayer == nil{
            let urlpath = Bundle.main.path(forResource: "bgmusic", ofType: "mp3")
            let url = URL(fileURLWithPath: urlpath!)
            let _: NSError?
            do {
                MainViewController.audioPlayer = try AVAudioPlayer(contentsOf: url)
            }
            catch let error {
                print(error)
            }
            MainViewController.audioPlayer.isMeteringEnabled = true
            MainViewController.audioPlayer.prepareToPlay()
            MainViewController.audioPlayer.numberOfLoops = -1
            MainViewController.audioPlayer.volume = 0.4
            MainViewController.audioPlayer.play()
        }
    }

    @objc func setToPlay(notification: NSNotification) {
        MainViewController.audioPlayer.play()
    }
    @objc func setToPause(notfication: NSNotification) {
        MainViewController.audioPlayer.pause()
    }
}

