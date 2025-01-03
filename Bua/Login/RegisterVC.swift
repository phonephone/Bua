//
//  RegisterVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    var masterJSON:JSON?
    
    var otpSMSBool = false
    var otpEmailBool = false
    
    var newsLetterBool = false
    var personalDataBool = false
    
    var otpJSON:JSON?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var telField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var otpSMSBtn: UIButton!
    @IBOutlet weak var otpSMSTitle: UIButton!
    @IBOutlet weak var otpEmailBtn: UIButton!
    @IBOutlet weak var otpEmailTitle: UIButton!
    @IBOutlet weak var otpRequestBtn: UIButton!
    
    @IBOutlet weak var otpStack: UIStackView!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var otpSubmitBtn: UIButton!
    @IBOutlet weak var otpRefCode: UILabel!
    
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var repassField: UITextField!
    
    @IBOutlet weak var newsLetterBtn: UIButton!
    @IBOutlet weak var personalDataBtn: UIButton!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("REGISTER")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myScrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        
        setupTextField(telField)
        setupTextField(emailField)
        
        setupTextField(otpField)
        
        setupTextField(passField)
        setupTextField(repassField)
        
        otpRequestBtn.disableBtn()
        showOTPStack(false)
        showPassword(false)
    }
    
    func setupTextField(_ field:UITextField) {
        field.delegate = self
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == telField || textField == emailField {
            checkOTPRequestField()
        }
        else if textField == otpField {
            checkOTPSubmitField()
        }
        else if textField == passField || textField == repassField {
            checkPasswordField()
        }
        
        if telField.text == "888" {
            telField.text = "0815545126"
            emailField.text = "trukkara@gmail.com"
            checkOTPRequestField()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == telField {
            emailField.becomeFirstResponder()
            return true
        } 
        else if textField == emailField {
            emailField.resignFirstResponder()
            return true
        } 
        else if textField == otpField {
            otpField.resignFirstResponder()
            return true
        }
        else if textField == passField {
            repassField.becomeFirstResponder()
            return true
        }
        else if textField == repassField {
            repassField.resignFirstResponder()
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func smsClick(_ sender: UIButton) {
        otpSMSBool.toggle()
        otpSMSBtn.checkboxEnable(otpSMSBool)
        
        otpEmailBool = false
        otpEmailBtn.checkboxEnable(otpEmailBool)
        
        checkOTPRequestField()
    }
    
    @IBAction func emailClick(_ sender: UIButton) {
        otpEmailBool.toggle()
        otpEmailBtn.checkboxEnable(otpEmailBool)
        
        otpSMSBool = false
        otpSMSBtn.checkboxEnable(otpSMSBool)
        
        checkOTPRequestField()
    }
    
    // MARK: - OTP Request
    func checkOTPRequestField() {
        if telField.text!.isValidPhoneNumber && emailField.text!.isValidEmail && (otpSMSBool || otpEmailBool) {
            otpRequestBtn.enableBtn()
        }
        else{
            otpRequestBtn.disableBtn()
        }
    }
    
    @IBAction func otpRequestClick(_ sender: UIButton) {
        loadOTPRequest()
    }
    
    func loadOTPRequest() {
        
        var parameters:Parameters = ["phone_no":telField.text!,
                                     "email":emailField.text!]
        
        if otpSMSBool {
            parameters.updateValue("phone_no", forKey: "otp_type")
        }
        else if otpEmailBool {
            parameters.updateValue("email", forKey: "otp_type")
        }
        print(parameters)
        loadRequest(method:.post, apiName:"registerOtp", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS OTP REQUEST\(json)")
                
                self.otpJSON = json["data"]
                self.otpRefCode.text = self.otpJSON!["ref_otp"].stringValue
                
                self.showOTPStack(true)
            }
        }
    }
    
    func showOTPStack(_ on: Bool) {
        otpField.text = ""
        otpSubmitBtn.disableBtn()
        checkOTPSubmitField()
        
        if on {//LOCK > Show OTP
            telField.disableField()
            emailField.disableField()
            
            otpSMSBtn.checkboxDisable(otpSMSBool)
            otpSMSTitle.disableIconBtn()
            otpEmailBtn.checkboxDisable(otpEmailBool)
            otpEmailTitle.disableIconBtn()
            
            otpRequestBtn.isHidden = true
            otpStack.isHidden = false
        }
        else {//UNLOCK > Hide OTP
            telField.enableField()
            emailField.enableField()
            
            otpSMSBtn.checkboxEnable(otpSMSBool)
            otpSMSTitle.enableIconBtn()
            otpEmailBtn.checkboxEnable(otpEmailBool)
            otpEmailTitle.enableIconBtn()
            
            otpRequestBtn.isHidden = false
            otpStack.isHidden = true
        }
    }
    
    @IBAction func otpResendClick(_ sender: UIButton) {
        loadOTPRequest()
    }
    
    @IBAction func otpEditClick(_ sender: UIButton) {
        showOTPStack(false)
    }
    
    
    // MARK: - OTP SUBMIT
    func checkOTPSubmitField() {
        if otpField.text!.isValidOTP {
            otpSubmitBtn.enableBtn()
        }
        else{
            otpSubmitBtn.disableBtn()
        }
    }
    
    @IBAction func otpSubmitClick(_ sender: UIButton) {
        loadOTPSubmit()
    }
    
    func loadOTPSubmit() {
        let parameters:Parameters = ["phone_no":telField.text!,
                                     "email":emailField.text!,
                                     "otp_code":otpField.text!,
                                     "ref_otp":otpRefCode.text!,
        ]
        print(parameters)
        loadRequest(method:.post, apiName:"checkRegisterOtp", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS OTP SUBMIT\(json)")
                
                self.showPassword(true)
            }
        }
    }
    
    func showPassword(_ on: Bool) {
        checkPasswordField()
        
        if on {//Show Password
            otpStack.isHidden = true
            passwordStack.isHidden = false
        }
        else {//Hide Password
            passwordStack.isHidden = true
        }
    }
    
    // MARK: - PASSWORD SUBMIT
    func checkPasswordField() {
        if passField.text!.isValidPassword && passField.text! == repassField.text! {//}&& newsLetterBool && personalDataBool {
            submitBtn.enableBtn()
        }
        else{
            submitBtn.disableBtn()
        }
    }
    
    @IBAction func termClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ConsentVC") as! ConsentVC
        vc.consentMode = .term
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func privacyClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ConsentVC") as! ConsentVC
        vc.consentMode = .privacy
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func newsLetterClick(_ sender: UIButton) {
        newsLetterBool.toggle()
        newsLetterBtn.checkboxEnable(newsLetterBool)
        checkPasswordField()
    }
    
    @IBAction func personalDataClick(_ sender: UIButton) {
        personalDataBool.toggle()
        personalDataBtn.checkboxEnable(personalDataBool)
        checkPasswordField()
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        pushToNextVC()
    }
    
    func pushToNextVC() {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "RegisterTaxVC") as! RegisterTaxVC
        vc.masterJSON = masterJSON
        vc.phoneNumber = telField.text
        vc.email = emailField.text
        vc.password = passField.text
        
        if newsLetterBool {
            vc.agreement1 = "1"
        } else {
            vc.agreement1 = "0"
        }
        
        if personalDataBool {
            vc.agreement2 = "1"
        } else {
            vc.agreement2 = "0"
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
