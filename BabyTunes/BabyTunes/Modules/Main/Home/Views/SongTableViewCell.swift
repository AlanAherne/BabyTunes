//
//  SongTableViewCell.swift
//  ColorMatchTabs
//
//  Created by anna on 6/15/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var contentImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    
    func apply(_ song: Song) {
        contentImageView.image = song.songImage
        songTitle.text = song.title
        songTitle.font = UIFont.cellTitleFont()
    }
    
}
