//
//  BTSong.swift
//  BabyTunes
//
//  Created by Alan Aherne Restore on 07.09.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//
import UIKit
import RealmSwift

open class Song: Object {
    
    @objc dynamic var title: String! = ""
    @objc dynamic var locked = true
    
    @objc dynamic var language = Language.england.rawValue
    var languageEnum: Language {
        get {
            return Language(rawValue: language)!
        }
        set {
            language = newValue.rawValue
        }
    }
}
