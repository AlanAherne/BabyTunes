//
//  Extensions.swift
//  BabyTunes
//
//  Created by Alan Aherne on 18.12.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let playBGMusic = Notification.Name("playBGMusic")
    static let pauseBGMusic = Notification.Name("pauseBGMusic")
}

extension UserDefaults {
    func containsLangauge(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

extension Collection where Index == Int {
    
    /**
     Picks a random element of the collection.
     
     - returns: A random element of the collection.
     */
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
    
}
