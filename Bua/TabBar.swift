//
//  TabBar.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import UIKit

class TabBar: UITabBarController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .mainTheme
        self.tabBar.unselectedItemTintColor = .textGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Constants.Font.tabbar], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Constants.Font.tabbarSelect], for: .selected)
        
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.2
        
        let prominentTabBar = self.tabBar as! ProminentTabBar
            prominentTabBar.prominentButtonCallback = prominentTabTaped
    }
    
    func prominentTabTaped() {
        selectedIndex = (tabBar.items?.count ?? 0)/2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.safeAreaInsets.bottom > 0 {//Detect Safe Area Bottom
            tabBar.frame.size.height = 90
            for tabBarItem in (tabBar.items)!{
                
                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
                
                let verticalOffset = -5.0
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
                
//                if tabBarItem.tag != 3 {//Exclude Center Tab
//                    tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
//                    
//                    let verticalOffset = -5.0
//                    
//                    if tabBarItem.tag == 1 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                    else if tabBarItem.tag == 2 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                    else if tabBarItem.tag == 4 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                    else if tabBarItem.tag == 5 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                }
            }
        }
        else{//lower
            tabBar.frame.size.height = 60
            for tabBarItem in (tabBar.items)!{
                
                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
                
                let verticalOffset = -8.0
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
                
//                if tabBarItem.tag != 3 {//Exclude Center Tab
//                    tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
//                    
//                    let verticalOffset = -8.0
//                    
//                    if tabBarItem.tag == 1 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                    else if tabBarItem.tag == 2 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                    else if tabBarItem.tag == 4 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                    else if tabBarItem.tag == 5 {
//                        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: verticalOffset)
//                    }
//                }
            }
        }
        tabBar.frame.origin.y = view.frame.height - tabBar.frame.size.height
        
        //tabBar(tabBar, didSelect: tabBar.items!.first!)
    }
}
