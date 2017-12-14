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
        image = UIImage(named: songTitle + ".jpg")
        
        super.init()
    }
    
    var title: String!
    var language: String!
    var image: UIImage!
    var length: Int?
    var songData: NSObject?
    var lyrics: NSObject?
}
