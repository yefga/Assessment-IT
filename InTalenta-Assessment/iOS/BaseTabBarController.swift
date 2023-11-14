//
//  BaseTabBarController.swift
//  InTalenta-Assessment
//
//  Created by pro on 13/11/23.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        
        // Create and add view controllers to the tab bar
        let firstVC = AnimalSearchVC(store: .init(initialState: AnimalReducer.State(), reducer: { AnimalReducer() }))
        let firstViewController = UINavigationController(rootViewController: firstVC)
        
        let secondVC = AnimalFavoriteVC(store: .init(initialState: AnimalFavoriteReducer.State(), reducer: { AnimalFavoriteReducer() }))
        let secondViewController = UINavigationController(rootViewController: secondVC)
        
        // Customize view controllers if needed
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        // Set view controllers for the tab bar controller
        viewControllers = [firstViewController, secondViewController]
    }
    
}
