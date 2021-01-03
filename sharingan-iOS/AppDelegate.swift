//
//  AppDelegate.swift
//  sharingan-iOS
//
//  Created by 肖楚🐑 on 2021/1/1.
//
//

import UIKit
#if DEBUG
import DoraemonKit
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        DoraemonManager.shareInstance().install()
        DoraemonManager.shareInstance().showDoraemon()
        #endif
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController.init(rootViewController: CameraViewController.init())
        window?.makeKeyAndVisible()
        return true
    }


}
