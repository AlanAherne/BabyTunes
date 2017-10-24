//
//  BTSong.swift
//  BabyTunes
//
//  Created by Alan Aherne Restore on 07.09.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//
import UIKit

open class Song: NSObject {
    
    init(fromLanguage songLanguage: String, songTitle: String) {
        
        language = songLanguage
        title = songTitle
        thumbNailImage = UIImage(named: songTitle + "_THM.png")  
        super.init()
    }
    
    var title: String!
    var language: String!
//AA    var image: UIImage!
    var thumbNailImage: UIImage!
    var length: Int?
    var songData: NSObject?
    var lyrics: NSObject?
}
