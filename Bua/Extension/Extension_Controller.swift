//
//  Extension_Controller.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import Foundation
import UIKit
import SideMenuSwift

// MARK: - UIStoryboard
extension UIStoryboard  {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
    static let settingStoryBoard = UIStoryboard(name: "Settings", bundle: nil)
}

// MARK: - UIViewController
extension UIViewController {
    
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func unEmbed(_ viewController:UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.didMove(toParent: nil)
    }
    
    func switchToLogin() {
        self.navigationController!.setViewControllers([Constants.Controller.initLogin()], animated: true)
    }
    
    func switchToHome() {
        self.navigationController!.setViewControllers([Constants.Controller.initSideMenuAndHome()], animated: true)
    }
    
    func switchToError() {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ServerError")
        self.navigationController!.setViewControllers([vc], animated: true)
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey:Constants.API.userIDKey)
        self.switchToLogin()
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func blurViewSetup() -> UIVisualEffectView{
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView (effect: blurEffect)
        blurView.bounds = self.view.bounds
        blurView.center = self.view.center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tap)
        
        return blurView
    }
    
    func popIn(popupView : UIView) {
        var backgroundView:UIView
        if let tabBarView = self.tabBarController?.view {
            backgroundView = tabBarView
        }
        else {
            backgroundView = self.view
        }
        
        //        let blurView = blurViewSetup()
        //        blurView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        //        blurView.alpha = 0
        //        backgroundView!.addSubview(blurView)
        
        //popupView.center = backgroundView!.center
        popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        popupView.alpha = 0
        
        backgroundView.addSubview(popupView)
        
        UIView.animate(withDuration: 0.3, animations:{
            //blurView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //blurView.alpha = 1
            
            popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            popupView.alpha = 1
        })
    }
    
    func popOut(popupView : UIView) {
        UIView.animate(withDuration: 0.3, animations:{
            popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            popupView.alpha = 1
        }, completion: {_ in
            popupView.removeFromSuperview()
        })
    }
    
    @objc func blurViewTapped(_ sender: UITapGestureRecognizer) {
        //sender.view?.removeFromSuperview()
        print("Tap Blur")
    }
}

// MARK: - UINavigationController
extension UINavigationController {
    
    func setStatusBarColor(backgroundColor: UIColor? = nil) {

        var statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            statusBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0)
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        
        let statusBarView = UIView(frame: statusBarFrame)
        
        if (backgroundColor != nil) {
            statusBarView.backgroundColor = backgroundColor
        }
        else{
            statusBarView.backgroundColor = .mainTheme//backgroundColor
        }
        
        view.addSubview(statusBarView)
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}

// MARK: - UITabBarController
extension UITabBarController {
    
    func setStatusBarColor(backgroundColor: UIColor? = nil) {

        var statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            statusBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0)
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        
        let statusBarView = UIView(frame: statusBarFrame)
        
        if (backgroundColor != nil) {
            statusBarView.backgroundColor = backgroundColor
        }
        else{
            statusBarView.backgroundColor = .mainTheme//backgroundColor
        }
        
        view.addSubview(statusBarView)
    }
}
