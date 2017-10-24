//
//  AWCollectionCellCollectionViewCell.swift
//  AWCollectionViewDialLayoutDemo
//
//  Created by Moayad on 5/29/16.
//  Copyright © 2016 Moayad. All rights reserved.
//

import UIKit

class AWCollectionCell: UICollectionViewCell {
    @IBOutlet weak var icon:UIImageView!
    @IBOutlet weak var label:UILabel!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func configure(_ song: Song)
    {
        self.label.layer.masksToBounds = true
        
        self.label.adjustsFontSizeToFitWidth = true
        var attributes = [NSAttributedStringKey : Any]()
        attributes = [.strokeWidth: -3.0, .strokeColor: UIColor.black, .foregroundColor: UIColor.white]
        
        self.label.attributedText = NSAttributedString(string: song.title, attributes: attributes)
        
        self.icon.image = song.thumbNailImage
        self.icon.layer.borderWidth = 2
        self.icon.layer.borderColor = UIColor.white.cgColor
        self.icon.setRounded()
    }
}
