//
//  ForgetPasswordVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class ForgetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("FORGET PASSWORD")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        emailField.delegate = self
        emailField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        submitBtn.disableBtn()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if emailField.text!.isValidEmail {
            submitBtn.enableBtn()
        }
        else{
            submitBtn.disableBtn()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.text! == "" {
            return false
        }
        else {
            return false
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        loadForget()
    }
    
    func loadForget() {
        let parameters:Parameters = ["email":emailField.text!]
        loadRequest(method:.post, apiName:"forgetPassword", authorization:true, showLoadingHUD:true, dismissHUD:false, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS FORGET\(json)")
                
                self.showSubmitSuccess(withText:json["message"].stringValue.html2String)
                {
                    //Do something after delay
                }
            }
        }
    }
}

