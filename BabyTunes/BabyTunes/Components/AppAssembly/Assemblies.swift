//
//  Assemblies.swift
//  BabyTunes
//
//  Created by Alan Aherne on 30.09.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import Swinject

// MARK: Window handler
class WindowHandlerAssembly: AssemblyProtocol {
    
    static func install(_ container: Container) {
        container.register(WindowHandlerProtocol.self) { r in
        
            WindowHandler()
            
            }.inObjectScope(.container)
    }
}
