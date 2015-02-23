//
//  SlideInCellAnimator.swift
//  BabyTunes
//
//  Created by Alan Aherne Restore on 07.02.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//

import UIKit
import QuartzCore

let SlideInCellAnimatorStartTransform:CATransform3D = {
    var translation = CATransform3DMakeTranslation(0, 480, 0);
    
    return translation
    }()

class SlideInCellAnimator {
    class func animate(cell:UITableViewCell) {
        cell.layer.shadowColor = UIColor.blackColor().CGColor;
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = SlideInCellAnimatorStartTransform;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        //!!!FIX for issue #1 Cell position wrong------------
        if(cell.layer.position.x != 0){
            cell.layer.position = CGPointMake(0, cell.layer.position.y);
        }
        
        //4. Define the final state (After the animation) and commit the animation
        UIView.animateWithDuration(0.8) {
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
        }
    }
}