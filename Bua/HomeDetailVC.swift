//
//  HomeDetailVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 26/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import ProgressHUD

class HomeDetailVC: UIViewController {
    
    var annoucementJSON:JSON?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("HOME DETAIL")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myScrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        myImage.sd_setImage(with: URL(string:annoucementJSON!["slide_cover_image"].stringValue), placeholderImage: nil)
        myTextView.text = annoucementJSON!["slide_content"].stringValue.html2String
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
