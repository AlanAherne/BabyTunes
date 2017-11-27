//
//  StubContentViewControllersProvider
//  BabyTunes
//
//  Created by Alan Aherne on 03.11.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {
    
    static let viewControllers: [UIViewController] = {
        let productsViewController = StubContentViewController()
        productsViewController.language = .england
        
        let venuesViewController = StubContentViewController()
        venuesViewController.language = .germany
        
        let reviewsViewController = StubContentViewController()
        reviewsViewController.language = .france
        
        let usersViewController = StubContentViewController()
        usersViewController.language = .spain
        
        return [productsViewController, venuesViewController, reviewsViewController, usersViewController]
    }()
    
}

