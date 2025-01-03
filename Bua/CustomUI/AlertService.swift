//
//  AlertService.swift
//  Saw Grow
//
//  Created by Truk Karawawattana on 30/3/2566 BE.
//

import UIKit

class AlertService {
    
    func alert(title: String, body: String, actionBtnTitle: String, completion: @escaping () -> Void) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.alertTitle = title
        alertVC.alertBody = body
        alertVC.actionButtonTitle = actionBtnTitle
        
        alertVC.buttonAction = completion
        
        return alertVC
    }
}
