//
//  NumbersConfigurator.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import Utils
import Services

/// Configurator for Numbers module
final class NumbersConfigurator {
    
    /// Configures view controller which is ready to present Numbers module
    ///
    /// - Returns: view controller to present
    static func configureModule() -> UIViewController {
        let localView = NumbersViewController(style: .plain)
        localView.title = Localizations.Numbers.localNumbers
        localView.tabBarItem.image = #imageLiteral(resourceName: "random.png")
        let localPresenter = NumbersPresenter()
        localPresenter.numbersService = Services.servicesFactory.localNumbersService
        localView.output = localPresenter
        localPresenter.view = localView
        
        let remoteView = NumbersViewController(style: .plain)
        remoteView.title = Localizations.Numbers.remoteNumbers
        remoteView.tabBarItem.image = #imageLiteral(resourceName: "remote.png")
        let remotePresenter = NumbersPresenter()
        remotePresenter.numbersService = Services.servicesFactory.remoteNumbersService
        remoteView.output = remotePresenter
        remotePresenter.view = remoteView
        
        let viewController = UITabBarController()
        viewController.viewControllers = [
            UINavigationController(rootViewController: localView),
            UINavigationController(rootViewController: remoteView)]
        
        return viewController
    }
}
