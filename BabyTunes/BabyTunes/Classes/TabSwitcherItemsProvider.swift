//
//  TabSwitcherItemsProvider.swift
//  BabyTunes
//
//  Created by Alan Aherne on 03.11.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//
import UIKit
import ColorMatchTabs

class TabSwitcherItemsProvider {
    
    static let items = {
        return [
            TabItem(
                title: Language.england.languageName(),
                tintColor: UIColor(red: 0.51, green: 0.72, blue: 0.25, alpha: 1.00),
                normalImage: Language.england.languageMouseCharacterIconImage(),
                highlightedImage: Language.england.languageMouseCharacterIconImage()
            ),
            TabItem(
                title: Language.germany.languageName(),
                tintColor: UIColor(red: 0.15, green: 0.67, blue: 0.99, alpha: 1.00),
                normalImage: Language.germany.languageMouseCharacterIconImage(),
                highlightedImage: Language.germany.languageMouseCharacterIconImage()
            ),
            TabItem(
                title: Language.france.languageName(),
                tintColor: UIColor(red: 0.96, green: 0.61, blue: 0.58, alpha: 1.00),
                normalImage: Language.france.languageMouseCharacterIconImage(),
                highlightedImage: Language.france.languageMouseCharacterIconImage()
            ),
            TabItem(
                title: Language.spain.languageName(),
                tintColor: UIColor(red: 1.00, green: 0.61, blue: 0.16, alpha: 1.00),
                normalImage: Language.spain.languageMouseCharacterIconImage(),
                highlightedImage: Language.spain.languageMouseCharacterIconImage()
            )
        ]
    }()
    
}
