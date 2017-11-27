//
//  WindowHandler.swift
//  BabyTunes
//
//  Created by Alan Aherne on 30.09.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import UIKit

class WindowHandler: WindowHandlerProtocol {
    
    func show(state: WindowHandlerState) {
        switch state {
        case .app: showApp()
        }
    }    
}



// Handle Windows
extension WindowHandler {
    
    fileprivate func showApp() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDelegate.window == nil {
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        }
        appDelegate.window?.rootViewController = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()
        appDelegate.window?.makeKeyAndVisible()
    }
}
