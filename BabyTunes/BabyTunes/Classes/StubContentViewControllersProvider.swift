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
        let englishViewController = StubContentViewController()
        englishViewController.language = .england
        
        let germanViewController = StubContentViewController()
        germanViewController.language = .germany
        
        let frenchViewController = StubContentViewController()
        frenchViewController.language = .france
        
        let spanishViewController = StubContentViewController()
        spanishViewController.language = .spain
        
        return [englishViewController, germanViewController, frenchViewController, spanishViewController]
    }()
    
}

