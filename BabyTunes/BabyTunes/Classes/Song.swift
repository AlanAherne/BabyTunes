//
//  BTSong.swift
//  BabyTunes
//
//  Created by Alan Aherne Restore on 07.09.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//

import UIKit
import Parse

public class Song: PFObject, PFSubclassing {
    
    override public class func initialize() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String {
        return "Song"
    }
    
    @NSManaged public var title: String!
    @NSManaged public var language: String!
    @NSManaged public var length: Int
    @NSManaged public var imageFile: PFFile!
    @NSManaged public var songData: PFFile!
    @NSManaged public var Lyrics: PFFile!
}