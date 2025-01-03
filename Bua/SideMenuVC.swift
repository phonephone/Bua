//
//  SideMenuVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 26/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class SideMenuVC: UIViewController {
    
    var menuJSON:JSON?
    
    @IBOutlet var sideMenuTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var appVersion: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = Constants.GlobalVariables.mainJSON?["user_name"].stringValue
        emailLabel.text = Constants.GlobalVariables.mainJSON?["email"].stringValue
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        if setColor {
    //            self.navigationController?.setStatusBarColor()
    //            bottomView.setGradientBackground(colorTop: .white, colorBottom: UIColor.customThemeColor())
    //
    //            setColor = false
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SIDE MENU")
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.backgroundColor = .clear
        sideMenuTableView.separatorStyle = .none
        
        appVersion.text = "\(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))"
    }
    
    func selectDefaultMenu(rowNo:Int) {
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row:rowNo, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
            
            let cell = (self.sideMenuTableView.cellForRow(at: defaultRow) as? SideMenuCell)!
            cell.menuImage.setImageColor(color: UIColor.mainTheme)
            cell.menuTitle.textColor = UIColor.mainTheme
        }
    }
}

// MARK: - UITableViewDataSource

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (menuJSON != nil) {
            return menuJSON!.count
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.hasNotch
        {//iphone X or upper
            return 65
        }
        else{
            return 60
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        //let cellArray = menuJSON![indexPath.row]
        
        
        //cell.menuImage.sd_setImage(with: URL(string:cellArray["menu_image_url"].stringValue), placeholderImage: UIImage(named: "logo_circle"))
        //cell.menuImage.setImageColor(color: UIColor.customThemeColor())
        
        switch indexPath.row {
        case 0:
            cell.menuImage.image = UIImage(named: "menu_point")//UIImage(systemName: "")
            cell.menuTitle.text = "คะแนนสะสม"
            
        case 1:
            cell.menuImage.image = UIImage(systemName: "key")
            cell.menuTitle.text = "เปลี่ยนรหัสผ่าน"
            
        case 2:
            cell.menuImage.image = UIImage(systemName: "bell")
            cell.menuTitle.text = "ตั้งค่าแจ้งเตือน"
            
        case 3:
            cell.menuImage.image = UIImage(systemName: "trash")
            cell.menuTitle.text = "ลบบัญชี"
            
        case 4:
            cell.menuImage.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            cell.menuTitle.text = "ออกจากระบบ"
            
        default:
            break
        }
        cell.menuImage.setImageColor(color: UIColor.mainTheme)
        
        cell.menuAlert.layer.cornerRadius = cell.menuAlert.frame.size.height/2
        cell.menuAlert.layer.masksToBounds = true
        
        cell.menuAlert.isHidden = true
        
        // Highlighted color
        let myHighlight = UIView()
        myHighlight.backgroundColor = UIColor.mainTheme
        myHighlight.backgroundColor = myHighlight.backgroundColor!.withAlphaComponent(0.2)
        myHighlight.layer.cornerRadius = 25
        cell.selectedBackgroundView = myHighlight
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath.row)")
        
        let cell = (tableView.cellForRow(at: indexPath) as? SideMenuCell)!
        cell.menuImage.setImageColor(color: UIColor.mainTheme)
        cell.menuTitle.textColor = UIColor.mainTheme
        
        switchMenu(menuNo:indexPath.row)
        deselectAll(sideMenuTableView)
    }
    
    func switchMenu(menuNo:Int) {
        self.sideMenuController!.hideMenu()
        
        switch menuNo {
        case 0:
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "PointVC") as! PointVC
            self.navigationController!.pushViewController(vc, animated: true)
            
        case 1:
            let vc = UIStoryboard.settingStoryBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
            self.navigationController!.pushViewController(vc, animated: true)
            
        case 2:
            let vc = UIStoryboard.settingStoryBoard.instantiateViewController(withIdentifier: "Settings") as! Settings
            self.navigationController!.pushViewController(vc, animated: true)
            
        case 3:
            let alertService = AlertService()
            let alertConfirm = alertService.alert(title: "ยืนยันการลบข้อมูลบัญชี", body: "กดยืนยันเพื่อออกจากระบบและไปยังหน้าลบข้อมูลบัญชีของคุณ", actionBtnTitle: "ยืนยัน") {
                self.logOut()
                if let url = URL(string: "https://rmcec.asiacement.co.th/profile/delete_account/\(Constants.GlobalVariables.userID)") {
                    UIApplication.shared.open(url)
                    //print(url)
                }
            }
            present(alertConfirm, animated: true)
            
        case 4:
            logOut()
            
        default:
            showComingSoon()
        }
    }
    
    func deselectAll(_ tableView: UITableView) {
        for i in 0..<4 {//menuJSON!.count {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
            
            if let cell = (tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SideMenuCell) {
                //cell.menuImage.image = cell.menuImage.image!.withRenderingMode(.alwaysOriginal)
                cell.menuImage.setImageColor(color: UIColor.mainTheme)
                cell.menuTitle.textColor = .textDarkGray
            }
        }
    }
}
