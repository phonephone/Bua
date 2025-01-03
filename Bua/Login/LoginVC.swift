//
//  LoginVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {

    var masterJSON:JSON?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var showPassBtn: UIButton!
    @IBOutlet weak var showPassTitle: UIButton!
    @IBOutlet weak var forgetPassBtn: UIButton!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var lineBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(Constants.API.domainURL)
        print(Constants.API.apiURL)
        
        print("LOGIN")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        emailField.delegate = self
        passField.delegate = self
        //emailField.returnKeyType = .next
        
        emailField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        passField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        submitBtn.disableBtn()
        
        loadMaster()
    }
    
    func loadMaster() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"masterData", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS MASTER\(json)")
                
                self.masterJSON = json["data"]
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (emailField.text!.isValidPhoneNumber || emailField.text!.isValidEmail) && passField.text!.isValidPassword {
            submitBtn.enableBtn()
        }
        else{
            submitBtn.disableBtn()
        }
        
        if emailField.text == "888" {//Bypass Login
            emailField.text = "jae.zaper@gmail.com"
            passField.text = "Qweqwe12#"
            submitBtn.enableBtn()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.text! == "" {
            return false
        } else if textField == emailField {
            passField.becomeFirstResponder()
            return true
        } else if textField == passField {
            passField.resignFirstResponder()
            return true
        }else {
            return false
        }
    }
    
    @IBAction func secureClick(_ sender: UIButton) {
        passField.isSecureTextEntry.toggle()
        showPassBtn.checkboxEnable(!passField.isSecureTextEntry)
//        if passField.isSecureTextEntry == true {
//            passField.isSecureTextEntry = false
//            showPassBtn.checkboxEnable(on: true)
//        }
//        else {
//            passField.isSecureTextEntry = true
//            showPassBtn.checkboxEnable(on: false)
//        }
    }
    
    @IBAction func forgetClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        loadLogin()
    }
    
    @IBAction func lineClick(_ sender: UIButton) {
        //lineAuthen()
    }
    
    @IBAction func googleClick(_ sender: UIButton) {
        //googleAuthen()
    }
    
    @IBAction func fbClick(_ sender: UIButton) {
        //facebookAuthen()
    }
    
    @IBAction func appleClick(_ sender: UIButton) {
        //appleAuthen()
    }
    
    @IBAction func registerClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        vc.masterJSON = masterJSON
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func consentClick(_ sender: UIButton) {
        if masterJSON == nil {
            loadMaster()
        }
        else {
            let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ConsentVC") as! ConsentVC
            vc.consentMode = .term
            vc.masterJSON = masterJSON
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        actionSheet.addAction(UIAlertAction(title: "ข้อกำหนดและเงื่อนไขการใช้งาน", style: .default, handler: { (UIAlertAction)in
//            vc.consentMode = .term
//            self.navigationController!.pushViewController(vc, animated: true)
//        }))
//        actionSheet.actions.last?.titleTextColor = .mainTheme
//        
//        actionSheet.addAction(UIAlertAction(title: "นโยบายความเป็นส่วนตัว", style: .default, handler: { (UIAlertAction)in
//            vc.consentMode = .privacy
//            self.navigationController!.pushViewController(vc, animated: true)
//        }))
//        actionSheet.actions.last?.titleTextColor = .mainTheme
//        
//        actionSheet.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: nil))
//        actionSheet.actions.last?.titleTextColor = .textGray
//        
//        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func loadLogin() {
        let parameters:Parameters = ["email":emailField.text!, "password":passField.text!]
        loadRequest(method:.post, apiName:"login", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS LOGIN\(json)")
                
                let userID = json["data"]["user_id"].stringValue
                print("USER ID = \(userID)")
                UserDefaults.standard.set(userID, forKey:Constants.API.userIDKey)
                Constants.GlobalVariables.userID = userID
                
                self.switchToHome()
            }
        }
    }
}
