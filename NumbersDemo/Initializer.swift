//
//  Initializer.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit

/// General initializaer for the whole app
final class Initializer {
    
    /// Setups window with the initial controller
    ///
    /// - Returns: window to present
    static func setupWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = NumbersConfigurator.configureModule()
        window.makeKeyAndVisible()
        return window
    }
}
