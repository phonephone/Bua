//
//  ResetPasswordVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class ResetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("FORGET PASSWORD")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        oldPassField.delegate = self
        oldPassField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        newPassField.delegate = self
        newPassField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        confirmPassField.delegate = self
        confirmPassField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        submitBtn.disableBtn()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if oldPassField.text!.isValidPassword && newPassField.text!.isValidPassword && newPassField.text == confirmPassField.text {
            submitBtn.enableBtn()
        }
        else{
            submitBtn.disableBtn()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if oldPassField.text! == "" {
            return false
        }
        else {
            return false
        }
    }
    
    func clearForm() {
        oldPassField.text = ""
        newPassField.text = ""
        confirmPassField.text = ""
        submitBtn.disableBtn()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        loadResetPassword()
    }
    
    func loadResetPassword() {
        let parameters:Parameters = ["user_id":Constants.GlobalVariables.userID,
                                     "old_password":oldPassField.text!,
                                     "new_password":newPassField.text!
        ]
        loadRequest(method:.post, apiName:"resetPassword", authorization:true, showLoadingHUD:true, dismissHUD:false, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS FORGET\(json)")
                
                self.showSubmitSuccess(withText:json["message"].stringValue.html2String)
                {
                    
                }
            }
        }
    }
}

