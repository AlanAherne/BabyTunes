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
        super.init()
    }
    
    var title: String!
    var language: String!
    var length: Int?
    var imageFile: NSObject?
    var imageThumbNailFile: NSObject?
    var songData: NSObject?
    var lyrics: NSObject?
}
