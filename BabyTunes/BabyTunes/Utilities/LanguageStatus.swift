//
//  LanguageStatus.swift
//  BabyTunes
//
//  Created by Alan Aherne on 14.12.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import Foundation

enum Language : Int
{
    case england = 1, germany, france, spain
    
    static let languageNames = [england : "english", germany : "german", france : "french", spain : "spanish"]
    static let languageMouseNames = [england : "MouseEN", germany : "MouseDE", france : "MouseFR", spain : "MouseSP"]
    static let languageTintColors = [england : UIColor(red: 0.51, green: 0.72, blue: 0.25, alpha: 1.00),
                                     germany : UIColor(red: 0.15, green: 0.67, blue: 0.99, alpha: 1.00),
                                     france : UIColor(red: 0.96, green: 0.61, blue: 0.58, alpha: 1.00),
                                     spain : UIColor(red: 1.00, green: 0.61, blue: 0.16, alpha: 1.00)]
    
    func languageTintColor() -> UIColor
    {
        if let languageTintColor = Language.languageTintColors[self]
        {
            return languageTintColor
        }
        return Language.languageTintColors[.england]!
    }
    
    func languageName() -> String
    {
        if let languageName = Language.languageNames[self]
        {
            return languageName
        }
        return Language.languageNames[.england]!
    }
    
    func languageMouseName() -> String
    {
        if let languageMouseName = Language.languageMouseNames[self]
        {
            return languageMouseName
        }
        return Language.languageMouseNames[.england]!
    }
    
    func languageMouseCharacterIconImage() -> UIImage!
    {
        return UIImage(named: "\(languageMouseName())")
    }
}
