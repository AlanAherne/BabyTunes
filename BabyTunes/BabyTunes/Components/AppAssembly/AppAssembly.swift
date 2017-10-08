//
//  AppAssembly.swift
//  BabyTunes
//
//  Created by Alan Aherne on 30.09.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import Foundation
import Swinject


class AppAssembly: AssemblyProtocol {
    
    class func container() -> Container {
        return AppAssemblyContainer.defaultContainer
    }
    
    class func install() {
        install(AppAssembly.container())
    }
    
    class func install(_ container: Container) {
        
 //AA       CRUDControllerAssembly.install(container)
 //AA       ThemerAssembly.install(container)
 //AA       LogicControllerAssembly.install(container)
        WindowHandlerAssembly.install(container)
        
    }
}
