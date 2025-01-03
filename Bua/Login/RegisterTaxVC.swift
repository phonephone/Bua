//
//  RegisterTaxVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class RegisterTaxVC: UIViewController, UITextFieldDelegate {
    
    var masterJSON:JSON?
    
    var phoneNumber : String?
    var email : String?
    var password : String?
    var agreement1 : String?
    var agreement2 : String?
    
    var fullTaxBool = false
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var companyField: MyField!
    @IBOutlet weak var nameField: MyField!
    @IBOutlet weak var taxIDField: MyField!
    
    @IBOutlet weak var fullTaxBtn: UIButton!
    @IBOutlet weak var fullTaxStack: UIStackView!
    
    @IBOutlet weak var branchField: MyField!
    @IBOutlet weak var addressField1: MyField!
    @IBOutlet weak var addressField2: MyField!
    
    @IBOutlet weak var provinceField: MyField!
    @IBOutlet weak var amphureField: MyField!
    @IBOutlet weak var tumbonField: MyField!
    @IBOutlet weak var postalField: MyField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var selectedCompanyID:String = ""
    var selectedBranchID:String = ""
    var selectedProvinceID:String = ""
    var selectedAmphureID:String = ""
    var selectedTumbonID:String = ""
    
    var companyJSON:JSON?
    var branchJSON:JSON?
    var provinceJSON:JSON?
    var amphureJSON:JSON?
    var tumbonJSON:JSON?
    
    var companyPicker: UIPickerView! = UIPickerView()
    var branchPicker: UIPickerView! = UIPickerView()
    var provincePicker: UIPickerView! = UIPickerView()
    var amphurePicker: UIPickerView! = UIPickerView()
    var tumbonPicker: UIPickerView! = UIPickerView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("REGISTER TAX")
//        print(phoneNumber!)
//        print(email!)
//        print(password!)
//        print(agreement1!)
//        print(agreement2!)
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myScrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        
        setupTextField(companyField)
        setupTextField(nameField)
        setupTextField(taxIDField)
        
        setupTextField(branchField)
        setupTextField(addressField1)
        setupTextField(addressField2)
        setupTextField(provinceField)
        setupTextField(amphureField)
        setupTextField(tumbonField)
        setupTextField(postalField)
        
        pickerSetup(picker: companyPicker)
        companyField.inputView = companyPicker
        
        pickerSetup(picker: branchPicker)
        branchField.inputView = branchPicker
        
        pickerSetup(picker: provincePicker)
        provinceField.inputView = provincePicker
        
        pickerSetup(picker: amphurePicker)
        amphureField.inputView = amphurePicker
        
        pickerSetup(picker: tumbonPicker)
        tumbonField.inputView = tumbonPicker
        
        companyField.isEnabled = false
        branchField.isEnabled = false
        provinceField.isEnabled = false
        amphureField.isEnabled = false
        tumbonField.isEnabled = false
        
        fullTaxStack.isHidden = true
        submitBtn.disableBtn()
        
        self.hideKeyboardWhenTappedAround()
        
        if masterJSON == nil {
            loadMaster()
        }
        else {
            setupMaster()
        }
    }
    
    func loadMaster() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"masterData", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS MASTER\(json)")
                
                self.masterJSON = json["data"]
                self.setupMaster()
            }
        }
    }
    
    func loadAmphure() {
        let parameters:Parameters = ["id_province":selectedProvinceID]
        loadRequest(method:.get, apiName:"amphure", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS AMPHURE\(json)")
                
                self.amphureJSON = json["data"]
                self.setupAmphure()
            }
        }
    }
    
    func loadTumbon() {
        let parameters:Parameters = ["id_amphure":selectedAmphureID]
        loadRequest(method:.get, apiName:"districts", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS TUMBON\(json)")
                
                self.tumbonJSON = json["data"]
                self.setupTumbon()
            }
        }
    }
    
    func setupMaster() {
        companyJSON = masterJSON!["type_company"]
        branchJSON = masterJSON!["company_branch"]
        provinceJSON = masterJSON!["provinces"]
        
        companyPicker.reloadAllComponents()
        branchPicker.reloadAllComponents()
        provincePicker.reloadAllComponents()
        
        companyField.isEnabled = true
        branchField.isEnabled = true
        provinceField.isEnabled = true
    }
    
    func setupAmphure() {
        amphurePicker.reloadAllComponents()
        amphurePicker.selectRow(0, inComponent: 0, animated: false)
        amphureField.isEnabled = true
        amphureField.text = ""
        selectedAmphureID = ""
        
        tumbonField.isEnabled = false
        tumbonField.text = ""
        selectedTumbonID = ""
        
        postalField.text = ""
        
        checkTaxField()
    }
    
    func setupTumbon() {
        tumbonPicker.reloadAllComponents()
        tumbonPicker.selectRow(0, inComponent: 0, animated: false)
        tumbonField.isEnabled = true
        tumbonField.text = ""
        selectedTumbonID = ""
        
        postalField.text = ""
        
        checkTaxField()
    }
    
    func setupTextField(_ field:UITextField) {
        field.delegate = self
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    func pickerSetup(picker:UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.setValue(UIColor.mainTheme, forKeyPath: "textColor")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == companyField && companyField.text == "" {
            selectPicker(companyPicker, didSelectRow: 0)
        }
        else if textField == branchField && branchField.text == "" {
            selectPicker(branchPicker, didSelectRow: 0)
        }
        else if textField == provinceField && provinceField.text == "" {
            selectPicker(provincePicker, didSelectRow: 0)
        }
        else if textField == amphureField && amphureField.text == "" {
            selectPicker(amphurePicker, didSelectRow: 0)
        }
        else if textField == tumbonField && tumbonField.text == "" {
            selectPicker(tumbonPicker, didSelectRow: 0)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkTaxField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == companyField {
            nameField.becomeFirstResponder()
            return true
        }
        else if textField == nameField {
            taxIDField.becomeFirstResponder()
            return true
        }
        else if textField == taxIDField {
            taxIDField.resignFirstResponder()
            return true
        }
        
        if textField == branchField {
            addressField1.becomeFirstResponder()
            return true
        }
        else if textField == addressField1 {
            addressField2.becomeFirstResponder()
            return true
        }
        else if textField == addressField2 {
            provinceField.becomeFirstResponder()
            return true
        }
        else if textField == provinceField {
            amphureField.becomeFirstResponder()
            return true
        }
        else if textField == amphureField {
            tumbonField.becomeFirstResponder()
            return true
        }
        else if textField == tumbonField {
            postalField.becomeFirstResponder()
            return true
        }
        else if textField == postalField {
            postalField.resignFirstResponder()
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func dropdownClick(_ sender: UIButton) {
        switch sender.tag {
        case 1://Company
            companyField.becomeFirstResponder()
            
        case 2://Branch
            branchField.becomeFirstResponder()
            
        case 3://Province
            provinceField.becomeFirstResponder()
            
        case 4://Amphure
            amphureField.becomeFirstResponder()
            
        case 5://Tumbon
            tumbonField.becomeFirstResponder()
            
        default:
            break
        }
    }
    
    @IBAction func fullTaxClick(_ sender: UIButton) {
        fullTaxBool.toggle()
        fullTaxBtn.checkboxEnable(fullTaxBool)
        
        fullTaxStack.isHidden = !fullTaxBool
        
        checkTaxField()
    }
    
    func checkTaxField() {
        if companyField.text!.isEmpty || nameField.text!.isEmpty || taxIDField.text!.count < 10 {
            submitBtn.disableBtn()
        }
        else{
            if fullTaxBool {
                if branchField.text!.isEmpty || addressField1.text!.isEmpty || provinceField.text!.isEmpty || amphureField.text!.isEmpty || tumbonField.text!.isEmpty || postalField.text!.count != 5 {
                    submitBtn.disableBtn()
                }
                else{
                    submitBtn.enableBtn()
                }
            }
            else {
                submitBtn.enableBtn()
            }
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        loadRegisterTax()
    }
    
    func loadRegisterTax() {
        var parameters:Parameters = ["email":email!,
                                     "phone_no":phoneNumber!,
                                     "password":password!,
                                     "agreement1":agreement1!,
                                     "agreement2":agreement2!,
                                     //"user_name":passField.text!,
                                     "company_type":selectedCompanyID,
                                     "company_name":nameField.text!,
                                     "id_card_no":taxIDField.text!,
        ]
        if fullTaxBool {
            parameters.updateValue("1", forKey: "tax_format")
            parameters.updateValue(selectedBranchID, forKey: "company_branch")
            parameters.updateValue(addressField1.text!, forKey: "address_address_1")
            parameters.updateValue(addressField2.text ?? "", forKey: "address_address_note")
            parameters.updateValue(selectedProvinceID, forKey: "address_province")
            parameters.updateValue(selectedAmphureID, forKey: "address_amphor")
            parameters.updateValue(selectedTumbonID, forKey: "address_tumbon")
            parameters.updateValue(postalField.text!, forKey: "address_zip")
        }
        else {
            parameters.updateValue("0", forKey: "tax_format")
        }
        print(parameters)
        
        loadRequest(method:.post, apiName:"saveRegister", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS REGISTER\(json)")
                
                let userID = json["data"]["user_id"].stringValue
                print("USER ID = \(userID)")
                UserDefaults.standard.set(userID, forKey:Constants.API.userIDKey)
                Constants.GlobalVariables.userID = userID
                
                self.switchToHome()
            }
        }
    }
}

// MARK: - Picker Datasource
extension RegisterTaxVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == companyPicker && companyJSON!.count > 0 {
            return companyJSON!.count
        }
        else if pickerView == branchPicker && branchJSON!.count > 0{
            return branchJSON!.count
        }
        else if pickerView == provincePicker && provinceJSON!.count > 0{
            return provinceJSON!.count
        }
        else if pickerView == amphurePicker && amphureJSON!.count > 0{
            return amphureJSON!.count
        }
        else if pickerView == tumbonPicker && tumbonJSON!.count > 0{
            return tumbonJSON!.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == companyPicker {
            return companyJSON![row]["name_type_company"].stringValue
        }
        else if pickerView == branchPicker {
            return branchJSON![row]["name_company_branch"].stringValue
        }
        else if pickerView == provincePicker {
            return provinceJSON![row]["name_th_provinces"].stringValue
        }
        else if pickerView == amphurePicker {
            return amphureJSON![row]["name_th_amphures"].stringValue
        }
        else if pickerView == tumbonPicker {
            return tumbonJSON![row]["name_th_districts"].stringValue
        }
        return nil
    }
}

// MARK: - Picker Delegate
extension RegisterTaxVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("Select \(row)")
        selectPicker(pickerView, didSelectRow: row)
    }
    
    func selectPicker(_ pickerView: UIPickerView, didSelectRow row: Int) {
        if pickerView == companyPicker {
            companyField.text = companyJSON![row]["name_type_company"].stringValue
            selectedCompanyID = companyJSON![row]["id_type_company"].stringValue
        }
        else if pickerView == branchPicker {
            branchField.text = branchJSON![row]["name_company_branch"].stringValue
            selectedBranchID = branchJSON![row]["id_company_branch"].stringValue
        }
        else if pickerView == provincePicker {
            provinceField.text = provinceJSON![row]["name_th_provinces"].stringValue
            selectedProvinceID = provinceJSON![row]["id_provinces"].stringValue
            loadAmphure()
        }
        else if pickerView == amphurePicker {
            amphureField.text = amphureJSON![row]["name_th_amphures"].stringValue
            selectedAmphureID = amphureJSON![row]["id_amphures"].stringValue
            loadTumbon()
        }
        else if pickerView == tumbonPicker {
            tumbonField.text = tumbonJSON![row]["name_th_districts"].stringValue
            selectedTumbonID = tumbonJSON![row]["id_districts"].stringValue
            postalField.text = tumbonJSON![row]["zip_code_districts"].stringValue
        }
        
        checkTaxField()
    }
}
