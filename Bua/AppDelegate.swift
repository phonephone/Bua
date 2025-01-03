//
//  AppDelegate.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .mainTheme
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorBackground = .clear//.lightGray
        ProgressHUD.colorStatus = .mainTheme
        ProgressHUD.fontStatus = Constants.Font.HUD
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

