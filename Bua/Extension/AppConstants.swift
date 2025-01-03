//
//  Constants.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import Foundation
import UIKit
import SideMenuSwift
import SwiftyJSON

struct Constants {
    struct GlobalVariables {
        static var userID = ""
        static var mainJSON:JSON?
    }
    
    struct Image {
        static let checkboxOff = UIImage(named: "checkbox_off")
        static let checkboxOn = UIImage(named: "checkbox_on")
        static let checkboxDisableOff = UIImage(named: "checkbox_disable_off")
        static let checkboxDisableOn = UIImage(named: "checkbox_disable_on")
    }
    
    struct Color {
        //static let themeColor = UIColor(named: "Main_Theme_1")!
    }
    
    struct Font {
        static let HUD = UIFont.custom_Medium(ofSize: 20)
        static let tabbar = UIFont.custom_Regular(ofSize: 10)
        static let tabbarSelect = UIFont.custom_SemiBold(ofSize: 10)
        
        static let headingBold = UIFont.custom_Bold(ofSize: 16)
        static let headingSemi = UIFont.custom_SemiBold(ofSize: 16)
        static let title = UIFont.custom_Medium(ofSize: 14)
        static let body = UIFont.custom_Regular(ofSize: 13)
        
        
        static let alertTitle = UIFont.custom_Medium(ofSize: 16)
        static let alertDescription = UIFont.custom_Medium(ofSize: 16)
        static let alertButton = UIFont.custom_Medium(ofSize: 16)
    }
    
    struct AlertText {
        static let confirmAction: String = "Confirm ?"
        static let okButton: String = "ยืนยัน"
        static let cancelButton: String = "ยกเลิก"
    }
    
    struct HUD {
        static let loadingText: String = "Loading"
        static let successText: String = "ข้อมูลถูกบันทึกเรียบร้อย"
        static let errorText: String = "เกิดข้อผิดพลาด"
        static let noDataText: String = "ไม่มีข้อมูล"
        static let comingSoonText: String = "Coming Soon"
    }
    
    struct API {
        static let domainURL = PlistParser.getKeysValue()!["domainName"]!
        static let apiURL = domainURL+PlistParser.getKeysValue()!["apiPath"]!
        
        static let userIDKey = "userID"
    }
    
    struct DateFormat {
        static let appDateFormat: String = "d MMM yyyy"
        static let appDateWithTimeFormat: String = "dd MMM yyyy HH:mm"
        static let appMonthYearFormat: String = "MMMM yyyy"
        
        static let serverDateFormat: String = "yyyy-MM-dd"
        static let serverDateWithTimeFormat: String = "yyyy-MM-dd HH:mm"
        static let serverMonthYearFormat: String = "yyyy-MM"
    }
    
    struct Controller {
        static func initLogin() -> UIViewController {
            return UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        }
        
        static func initSideMenuAndHome() -> UIViewController {
            let menuViewController = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
            let contentViewController = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBar
            
            let screenSize: CGRect = UIScreen.main.bounds
            
            SideMenuController.preferences.basic.menuWidth = screenSize.width*0.8
            SideMenuController.preferences.basic.position = .above
            SideMenuController.preferences.basic.direction = .left
            SideMenuController.preferences.basic.enablePanGesture = true
            SideMenuController.preferences.basic.supportedOrientations = .portrait
            SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
            
            return SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
        }
    }
}

// MARK: - Font & Value
extension UIFont {
    class func custom_Regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-Regular", size: size)!
    }
    class func custom_Medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-Medium", size: size)!
    }
    class func custom_SemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-SemiBold", size: size)!
    }
    class func custom_Bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-Bold", size: size)!
    }
}

// MARK: - Color
extension UIColor {
//    static let themeColor = UIColor(named: "Main_Theme_1")!
//    static let textGray = UIColor(named: "Text_Gray")!
//    static let textDarkGray = UIColor(named: "Text_Dark_Gray")!
//    static let textLightGray = UIColor(named: "Text_Light_Gray")!
//    static let buttonDisable = UIColor(named: "Btn_Disable")!
}
