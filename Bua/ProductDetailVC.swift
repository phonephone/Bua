//
//  ProductDetailVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 26/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class ProductDetailVC: UIViewController {
    
    var productJSON:JSON?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("HOME DETAIL")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
