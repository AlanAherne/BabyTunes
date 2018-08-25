//
//  ImageUtility.swift
//  BabyTunes
//
//  Created by Alan Aherne on 16.10.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
