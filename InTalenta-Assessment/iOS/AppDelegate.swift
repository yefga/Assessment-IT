//
//  AppDelegate.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 04/11/23.
//

import netfox
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NFX.sharedInstance().start()
        // Override point for customization after application launch.
        window = .init(frame: UIScreen.main.bounds)
        
        let vc = BaseTabBarController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStack().saveContext()
    }

}

