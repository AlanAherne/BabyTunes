//
//  Utility.swift
//  CircleMenu
//
//  Created by 刘业臻 on 16/6/25.
//  Copyright © 2016年 Alex K. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func distanceTo(_ pointB: CGPoint) -> CGFloat {
        let diffX = self.x - pointB.x
        let diffY = self.y - pointB.y

        return CGFloat(hypotf(Float(diffX), Float(diffY)))
    }
}

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat(Float(1.0) / Float(255.0) * Float(red)),
            green: CGFloat(Float(1.0) / Float(255.0) * Float(green)),
            blue: CGFloat(Float(1.0) / Float(255.0) * Float(blue)),
            alpha: CGFloat(alpha))
    }
}

internal extension Float {
    var radians: Float {
        return self * (Float(180) / Float(Double.pi))
    }

    var degrees: Float {
        return self  * Float(Double.pi) / 180.0
    }
}

internal extension UIView {

    var angleZ: Float {
        let radians: Float = atan2(Float(self.transform.b), Float(self.transform.a))
        return radians.radians
    }
}
