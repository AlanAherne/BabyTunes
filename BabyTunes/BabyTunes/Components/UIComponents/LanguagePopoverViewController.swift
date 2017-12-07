//
//  LanguagePopoverViewController.swift

import UIKit
import ColorMatchTabs

class LanguagePopoverViewController: PopoverViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
    }
    
    fileprivate func setupContentView() {
       
        self.view.backgroundColor = UIColor.green
        self.contentView.backgroundColor = UIColor.blue
        
 //AA       let imageView = UIImageView(image: UIImage(named: "AppIcon"))
 //AA       imageView.contentMode = .scaleAspectFit
 //AA       contentView.addSubview(imageView)
       
        let padding: CGFloat = 20
 //AA   imageView.translatesAutoresizingMaskIntoConstraints = false
 //AA        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
 //AA         imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
 //AA         imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//AA        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
 
 }
}
