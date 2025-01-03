//
//  SceneDelegate.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import UIKit
import SideMenuSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //UserDefaults.standard.removeObject(forKey:Constants.API.userIDKey)
        var userID = UserDefaults.standard.string(forKey:Constants.API.userIDKey)
        //userID = "4128" //Pom
        //userID = "4135" //TK Company Limited//Abc123##
        //userID = "1020" //Point History
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            var navigationController : UINavigationController
            
            if userID != nil {
                print("ALREADY LOGIN \(userID!)")
                Constants.GlobalVariables.userID = userID!

                navigationController = UINavigationController.init(rootViewController: Constants.Controller.initSideMenuAndHome())
            }
            else{
                print("1ST TIME")
                
                navigationController = UINavigationController.init(rootViewController: Constants.Controller.initLogin())
            }

            // MARK: - Bypass Login
            var bypassVC = UIViewController()
            
//            bypassVC = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
//            bypassVC = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            
//            bypassVC = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "RegisterTaxVC") as! RegisterTaxVC
            
//            bypassVC = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBar
            
//            bypassVC = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            
            bypassVC = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            
//            navigationController = UINavigationController.init(rootViewController: bypassVC)
            //Localize.setCurrentLanguage("en")
            //Localize.setCurrentLanguage("th")
            //Localize.setCurrentLanguage("zh")
            //Localize.resetCurrentLanguageToDefault()
            //print(Localize.defaultLanguage())
            //print(Localize.availableLanguages())
            
            
            // MARK: - End Bypass
            
            navigationController.setNavigationBarHidden(true, animated:false)
            window.rootViewController = navigationController// Your RootViewController in here
            window.makeKeyAndVisible()
            self.window = window
        }
        
        //guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

