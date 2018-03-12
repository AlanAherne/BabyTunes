
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setToPlay(notification:)), name: .playBGMusic, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setToPause(notfication:)), name: .pauseBGMusic, object: nil)
        
        initAudioPlayer()
        self.initEmitter()
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

