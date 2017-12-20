import UIKit
import AVFoundation

class RevealViewController: UIViewController, AVAudioPlayerDelegate {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
  
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var visualizerView: UIView!
    
    var song: Song?
    var swipeInteractionController: SwipeInteractionController?
    var visualizerTimer:Timer! = Timer()
    var audioVisualizer: ATAudioVisualizer!
    var lowPassResults1:Double! = 0.0
    var lowPassResult:Double! = 0.0
    var audioPlayer:AVAudioPlayer!
    var songTitel = ""
    let visualizerAnimationDuration = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let revealSong = song else {
            NSLog("no song set in the card view controller")
            return
        }
        
        imageView.image = UIImage(named: (revealSong.title)! + ".jpg")
        view.backgroundColor = revealSong.languageEnum.languageTintColor()
        swipeInteractionController = SwipeInteractionController(viewController: self)
        
        self.initAudioPlayer()
        self.initAudioVisualizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .pauseBGMusic, object: nil)
        self.audioPlayer.play()
        startAudioVisualizer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .playBGMusic, object: nil)
        self.audioPlayer.stop()
        stopAudioVisualizer()
    }
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func initAudioPlayer() {
        let urlpath     = Bundle.main.path(forResource: song?.title, ofType: "mp3")
        let url = URL(fileURLWithPath: urlpath!)
        let _: NSError?
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch let error {
            print(error)
        }
        audioPlayer.isMeteringEnabled = true
        self.audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
    
    
    func initAudioVisualizer() {
        if (self.audioVisualizer == nil){
            var frame = visualizerView.frame
            frame.origin.x = 0
            frame.origin.y = 0
            let visualizerColor = UIColor(red: 255.0 / 255.0, green: 84.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
            self.audioVisualizer = ATAudioVisualizer(barsNumber: 11, frame: frame, andColor: visualizerColor)
            visualizerView.addSubview(audioVisualizer)
        }
    }
    
    func startAudioVisualizer() {
        
        if visualizerTimer != nil
        {
            visualizerTimer.invalidate()
            visualizerTimer = nil
            
        }
        visualizerTimer = Timer.scheduledTimer(timeInterval: visualizerAnimationDuration, target: self, selector: #selector(visualizerTimerChanged), userInfo: nil, repeats: true)
    }
    
    func stopAudioVisualizer()
    {
        if visualizerTimer != nil
        {
            visualizerTimer.invalidate()
            visualizerTimer = nil
            
        }
        audioVisualizer.stop()
    }
    
    @objc func visualizerTimerChanged(_ timer:CADisplayLink)
    {
        audioPlayer.updateMeters()
        let ALPHA: Double = 1.05
        let averagePower: Double =  Double(audioPlayer.averagePower(forChannel: 0))
        let averagePowerForChannel: Double = pow(10, (0.05 * averagePower))
        lowPassResult = ALPHA * averagePowerForChannel + (1.0 - ALPHA) * lowPassResult
        let averagePowerForChannel1: Double = pow(10, (0.05 * Double(audioPlayer.averagePower(forChannel: 1))))
        lowPassResults1 = ALPHA * averagePowerForChannel1 + (1.0 - ALPHA) * lowPassResults1
        audioVisualizer.animate(withChannel0Level: self._normalizedPowerLevelFromDecibels(audioPlayer.averagePower(forChannel: 0)), andChannel1Level: self._normalizedPowerLevelFromDecibels(audioPlayer.averagePower(forChannel: 1)))
        self.updateLabels()
        
    }
    
    func updateLabels() {
        self.currentTimeLabel.text! = self.convertSeconds(Float(audioPlayer.currentTime))
        self.remainingTimeLabel.text! = self.convertSeconds(Float(audioPlayer.duration) - Float(audioPlayer.currentTime))
    }
    
    
    func convertSeconds(_ secs: Float) -> String {
        var currentSecs = secs
        if currentSecs < 0.1 {
            currentSecs = 0
        }
        var totalSeconds = Int(secs)
        if currentSecs > 0.45 {
            totalSeconds += 1
        }
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func _normalizedPowerLevelFromDecibels(_ decibels: Float) -> Float {
        if decibels < -60.0 || decibels == 0.0 {
            return 0.0
        }
        return powf((powf(10.0, 0.05 * decibels) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        playPauseButton.setImage(UIImage(named: "play_")!, for: UIControlState())
        playPauseButton.setImage(UIImage(named: "play")!, for: .highlighted)
        playPauseButton.isSelected = false
        self.currentTimeLabel.text! = "00:00"
        self.remainingTimeLabel.text! = self.convertSeconds(Float(audioPlayer.duration))
        self.stopAudioVisualizer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("audioPlayerDecodeErrorDidOccur")
        playPauseButton.setImage(UIImage(named: "play_")!, for: UIControlState())
        playPauseButton.setImage(UIImage(named: "play")!, for: .highlighted)
        playPauseButton.isSelected = false
        self.currentTimeLabel.text! = "00:00"
        self.remainingTimeLabel.text! = "00:00"
        self.stopAudioVisualizer()
    }
}
