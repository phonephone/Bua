//
//  Settings.swift
//  Saw Grow
//
//  Created by Truk Karawawattana on 8/8/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class Settings: UIViewController {
    
    var settingJSON:JSON?
    
    var setColor: Bool = true
    
    var emailBool: Bool = false
    var smsBool: Bool = false
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if setColor {
//            self.navigationController?.setStatusBarColor()
//            headerView.setGradientBackground()
//            
//            setColor = false
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SETTING")
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .clear
        //myCollectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        loadSetting()
    }
    
    func loadSetting() {
        let parameters:Parameters = ["user_id":Constants.GlobalVariables.userID]
        loadRequest(method:.get, apiName:"statusNotification", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                //ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS SETTIING\(json)")
                
                self.settingJSON = json["data"]
                self.myTableView.reloadData()
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
}//end ViewController

// MARK: - UITableViewDataSource

extension Settings: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (settingJSON != nil) {
            return 2//settingJSON!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SideMenuCell()
        
        //let cellArray = settingJSON![indexPath.item]
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuSwitch", for: indexPath) as! SideMenuCell
            
            cell.menuImage.image = UIImage(systemName: "envelope")
            cell.menuTitle.text = "แจ้งเตือน Email"
            
            cell.menuSwitch.tag = indexPath.row
            cell.menuSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
            cell.menuSwitch.isOn = settingJSON!["status_noti_email"].boolValue
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuSwitch", for: indexPath) as! SideMenuCell
            
            cell.menuImage.image = UIImage(systemName: "message")
            cell.menuTitle.text = "แจ้งเตือน SMS"
            
            cell.menuSwitch.tag = indexPath.row
            cell.menuSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
            cell.menuSwitch.isOn = settingJSON!["status_noti_sms"].boolValue
            
//        case 2:
//            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
//            
//            cell.menuImage.image = UIImage(systemName: "trash")
//            cell.menuTitle.text = "ลบบัญชี"
//            cell.menuArrow.isHidden = true
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        }
        
        if indexPath.row == settingJSON!.count-1 {
            let hideSeperator = UIEdgeInsets.init(top: 0, left: 2000,bottom: 0, right: 0)
            cell.separatorInset = hideSeperator
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension Settings: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath.row)")
        
//        if indexPath.row == 2 {//Delete
//            print("ลบบบบบบบบบบ")
//        }
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        switch sender.tag {
        case 0://Email
            loadNoti()
            
        case 1://Sms
            loadNoti()
            
        default:
            break
        }
        
        
    }
}

extension Settings {
    // MARK: - Line login
    func loadNoti() {
        let emailSwitchCell = (self.myTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SideMenuCell)!
        
        let smsSwitchCell = (self.myTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SideMenuCell)!
        
        let parameters:Parameters = ["user_id":Constants.GlobalVariables.userID,
                                     "status_noti_email":emailSwitchCell.menuSwitch.isOn.stringValue,
                                     "status_noti_sms":smsSwitchCell.menuSwitch.isOn.stringValue
        ]
        print(parameters)
        loadRequest(method:.post, apiName:"statusNotification", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                //ProgressHUD.dismiss()

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS UPDATE SWITCH\(json)")
                
                self.loadSetting()
            }
        }
    }
}
