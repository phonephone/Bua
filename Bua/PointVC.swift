//
//  PointVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 26/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

enum pointMode {
   case Reward
   case History
}

enum historyType {
   case get
   case use
}

struct Redeem {
    var RedeemImage: UIImage
    var RedeemName: String
    var RedeemName2: String
    var RedeemPrice: Int
}

struct History {
    var HistoryDate: String
    var HistoryType: historyType
    var HistoryPoint: Int
}

class PointVC: UIViewController {
    
    var mainJSON:JSON?
    var rewardJSON:JSON?
    var pointJSON:JSON?
    
    var mode:pointMode?
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
//    let demoRedeem = Redeem(RedeemImage: UIImage(named: "demo_point1")!,
//                           RedeemName: "น้ำเต้าหู้ปูปลา - สำราญราษฎร์",
//                           RedeemName2: "แลกคะแนน",
//                           RedeemPrice: 150)
//    
//    var redeemJSON = [Redeem]()
//    
//    let demoHistory = History(HistoryDate: "13 กันยายน 2566",
//                              HistoryType: .get,
//                              HistoryPoint: 500)
//    
//    var historyJSON = [History]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("REDEEM")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
//        initDemoRedeem()
//        initDemoHistory()
        
        reloadCollection()
    }
    
//    func initDemoRedeem() {
//        var demoRedeem1 = demoRedeem
//        
//        var demoRedeem2 = demoRedeem
//        demoRedeem2.RedeemImage = UIImage(named: "demo_point2")!
//        demoRedeem2.RedeemName = "ไอซ์ คอฟฟี่ ทีรามิสุ"
//        demoRedeem2.RedeemPrice = 150
//        
//        var demoRedeem3 = demoRedeem
//        demoRedeem3.RedeemImage = UIImage(named: "demo_point3")!
//        demoRedeem3.RedeemName = "ชุดจัดเต็มดับเบิลชีสเบอร์เกอร์สุดคุ้ม"
//        demoRedeem3.RedeemPrice = 450
//        
//        var demoRedeem4 = demoRedeem
//        demoRedeem4.RedeemImage = UIImage(named: "demo_point4")!
//        demoRedeem4.RedeemName = "P9 บลูทู ธ ไร้สายหูฟังไฮไฟสเตอริโอ"
//        demoRedeem4.RedeemPrice = 150
//        
//        redeemJSON = [demoRedeem1,demoRedeem2,demoRedeem3,demoRedeem4,demoRedeem1,demoRedeem2,demoRedeem3,demoRedeem4]
//    }
//    
//    func initDemoHistory() {
//        var demoHistory1 = demoHistory
//        
//        var demoHistory2 = demoHistory
//        demoHistory2.HistoryDate = "15 กันยายน 2566"
//        demoHistory2.HistoryType = .use
//        demoHistory2.HistoryPoint = 150
//        
//        var demoHistory3 = demoHistory
//        demoHistory3.HistoryDate = "17 กันยายน 2566"
//        demoHistory3.HistoryType = .get
//        demoHistory3.HistoryPoint = 200
//        
//        var demoHistory4 = demoHistory
//        demoHistory4.HistoryDate = "19 กันยายน 2566"
//        demoHistory4.HistoryType = .use
//        demoHistory4.HistoryPoint = 100
//        
//        var demoHistory5 = demoHistory
//        demoHistory5.HistoryDate = "22 กันยายน 2566"
//        demoHistory5.HistoryType = .use
//        demoHistory5.HistoryPoint = 180
//        
//        var demoHistory6 = demoHistory
//        demoHistory6.HistoryDate = "25 กันยายน 2566"
//        demoHistory6.HistoryType = .get
//        demoHistory6.HistoryPoint = 100
//        
//        historyJSON = [demoHistory1,demoHistory2,demoHistory3,demoHistory4,demoHistory5,demoHistory6]
//    }
    
    func reloadCollection() {
        if mode == .History {
            mode = .Reward
            loadReward()
        }
        else {
            mode = .History
            loadPoint()
        }
    }
    
    func loadReward() {
        let parameters:Parameters = ["user_id":Constants.GlobalVariables.userID]
        loadRequest(method:.get, apiName:"rewards", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS REWARD\(json)")
                
                self.mainJSON = json["data"]
                self.rewardJSON = json["data"]["reward"]
                self.myCollectionView.reloadData()
            }
        }
    }
    
    func loadPoint() {
        let parameters:Parameters = ["user_id":Constants.GlobalVariables.userID]
        loadRequest(method:.get, apiName:"historyPoint", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS POINT\(json)")
                
                self.mainJSON = json["data"]
                self.pointJSON = json["data"]["histories"]
                self.myCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func changeMode(_ sender: UIButton) {
        reloadCollection()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func sideMenuShow(_ sender: UIButton) {
        self.sideMenuController!.revealMenu()
    }
}

// MARK: - UICollectionViewDataSource

extension PointVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if mode == .Reward && rewardJSON != nil {
            return rewardJSON!.count
        }
        else if mode == .History && pointJSON != nil {
            return pointJSON!.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BasicCollectionCell_Header", for: indexPath) as? BasicCollectionCell_Header
        {
            if pointJSON != nil {
                headerCell.cellTitle.text = mainJSON!["myPoint"].stringValue
            }
            else {
                headerCell.cellTitle.text = "-"
            }
            
            return headerCell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if mode == .Reward {
            let cellArray = rewardJSON![indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"BasicCollectionCell", for: indexPath) as! BasicCollectionCell
            
            cell.cellImage.sd_setImage(with: URL(string:cellArray["rewardImg"].stringValue), placeholderImage: nil)
            cell.cellTitle.text = cellArray["rewardName"].stringValue
            cell.cellTitle2.text = cellArray["pointToUse"].stringValue
            //cell.cellDescription.text = "\(cellArray.RedeemPrice) บาท"
            
            return cell
        }
        else {//History
            let cellArray = pointJSON![indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"PointHistoryCollectionCell", for: indexPath) as! BasicCollectionCell
            
            cell.cellTitle.text = cellArray["datePoint"].stringValue
            
            cell.cellDescription.text = cellArray["dateText"].stringValue
            cell.cellDescription2.text = cellArray["point"].stringValue
            
            if cellArray["point"].intValue >= 0 {
                cell.cellDescription2.textColor = .darkGray
            }
            else {
                cell.cellDescription2.textColor = .red
            }
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PointVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerWidth = collectionView.frame.width
        let headerHeight = 140.0
        
        return CGSize(width: headerWidth, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = collectionView.frame.width
        
        if mode == .Reward {
            return CGSize(width: viewWidth , height: 135.0)
        }
        else if mode == .History {
            return CGSize(width: viewWidth , height: 100.0)
        }
        else {
            let viewHeight = 135.0
            //viewHeight*2.33
            return CGSize(width: viewWidth , height: viewHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: - UICollectionViewDelegate

extension PointVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
}

