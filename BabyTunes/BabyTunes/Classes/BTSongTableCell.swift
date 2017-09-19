//
//  BTSongTableCell.swift
//  BabyTunes
//
//  Created by Alan Aherne Restore on 04.02.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//
import BabyTunes
import UIKit

public class BTSongTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
   //AA http://stackoverflow.com/questions/25541786/custom-uitableviewcell-from-nib-in-swift
    
    public func configure(song: BabyTunes.Song)
    {
        debugPrint("Title", song.title)
        self.titleLabel.text = song.title
        self.titleLabel.textColor = UIColor.whiteColor();
        self.titleLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 18)
        
        // Create a white border with defined width
        self.cellImage!.layer.borderColor = UIColor.brownColor().CGColor
        self.cellImage!.layer.borderWidth = 2.5
        
        // Set image corner radius
        self.cellImage!.layer.cornerRadius = 5.0;
        
        self.cellImage!.clipsToBounds = true
        
        song.imageThumbNailFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            if let imageData = imageData where error == nil
            {
                self.cellImage!.image = UIImage(data: imageData)
            }
        }
    }
}