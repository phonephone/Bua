//
//  ProductVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 26/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

struct Product {
    var productImage: UIImage
    var productName: String
    var productName2: String
    var productPrice: Int
    var productStar: Int
    var productDesc: String
    var productDesc2: String
}

class ProductVC: UIViewController {
    
    //var productJSON:JSON?
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let demoProduct = Product(productImage: UIImage(named: "demo_product1")!,
                              productName: "ปูนซีเมนต์ ตราบัวพลัส",
                              productName2: "(บัวส้มโฉมใหม่)",
                              productPrice: 150,
                              productStar: 4,
                              productDesc: "ปูนซีเมนต์ตราบัวพลัส",
                              productDesc2: "เป็นปูนซีเมนต์สูตรพิเศษสำหรับงานฉาบโดยเฉพาะ ผลิต ตามมาตรฐานผลิตภัณฑ์อุตสาหกรรม มอก.2595-2556 ชนิด 125 และ ASTM C91 type S (Masonry cement)\nปูนตราบัวพลัสมีคุณสมบัติโดดเด่นเนื่องจากเนื้อปูนมีความละเอียดสูงมากกว่าปูนผสมทั่วไป")
    
    var productJSON = [Product]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("PRODUCT")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        var demoProduct1 = demoProduct
        
        var demoProduct2 = demoProduct
        demoProduct2.productImage = UIImage(named: "demo_product2")!
        demoProduct2.productName = "ปูนซีเมนต์ ตราบัวฟ้า"
        demoProduct2.productName2 = ""
        
        var demoProduct3 = demoProduct
        demoProduct3.productImage = UIImage(named: "demo_product3")!
        demoProduct3.productName = "ปูนซีเมนต์ บัวเขียว"
        demoProduct3.productName2 = ""
        
        var demoProduct4 = demoProduct
        demoProduct4.productImage = UIImage(named: "demo_product4")!
        demoProduct4.productName = "บัวมอร์ตาร์"
        demoProduct4.productName2 = "(ฉาบอิฐ มวลเบา)"
        
        productJSON = [demoProduct1,demoProduct2,demoProduct3,demoProduct4,demoProduct1,demoProduct2,demoProduct3,demoProduct4,demoProduct1,demoProduct2,demoProduct3,demoProduct4]
        
        loadProduct()
    }
    
    func loadProduct() {
        
    }
    
    @IBAction func sideMenuShow(_ sender: UIButton) {
        self.sideMenuController!.revealMenu()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if productJSON != nil {
            return productJSON.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BasicCollectionCell_Header", for: indexPath) as? BasicCollectionCell_Header
        {
            //headerCell.cellImage = UIImage(named: "")
            
            return headerCell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellArray = self.productJSON[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"BasicCollectionCell", for: indexPath) as! BasicCollectionCell
        
        cell.cellImage.image = cellArray.productImage
        cell.cellTitle.text = cellArray.productName
        cell.cellTitle2.text = cellArray.productName2
        cell.cellDescription.text = "\(cellArray.productPrice) บาท"
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerWidth = collectionView.frame.width
        let headerHeight = (headerWidth/430)*220
        
        return CGSize(width: headerWidth, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = (collectionView.frame.width-10)/2
        let viewHeight = (viewWidth/190)*290
        //viewHeight*2.33
        return CGSize(width: viewWidth , height: viewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UICollectionViewDelegate

extension ProductVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

