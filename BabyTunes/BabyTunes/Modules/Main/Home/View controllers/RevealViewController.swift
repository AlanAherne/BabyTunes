import UIKit

class RevealViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  var song: Song?
  var swipeInteractionController: SwipeInteractionController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = song?.title
    imageView.image = song?.image
    
    swipeInteractionController = SwipeInteractionController(viewController: self)

  }
  
  @IBAction func dismissPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
