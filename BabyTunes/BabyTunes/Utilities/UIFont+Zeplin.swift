//
//  UIFont+Zeplin.swift
//  BabyTunes
//
//  Created by Alan Aherne on 03.11.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func navigationTitleFont() -> UIFont? {
        return UIFont(name: "GothamPro-Black", size: 20.0)
    }
    
    class func cellTitleFont() -> UIFont? {
        return UIFont(name: "GothamPro-Medium", size: 18.0)
    }
    
    class func songTitleFont() -> UIFont? {
        return UIFont(name: "GothamPro", size: 15.0)
    }
    
    class func cellSubtitleFont() -> UIFont? {
        return UIFont(name: "GothamPro-Medium", size: 12.0)
    }
    
}
