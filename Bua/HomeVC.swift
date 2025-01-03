//
//  HomeVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 26/3/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import ProgressHUD

class HomeVC: UIViewController, UIScrollViewDelegate {
    
    var annoucementJSON:JSON?
    
    var announcementTimer: Timer?
    var announcementIndex: Int = 0
    
    var firstTime: Bool = true
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var announcementCollectionView: UICollectionView!
    @IBOutlet weak var announcementPageControl: UIPageControl!
    
    @IBOutlet weak var mainBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if annoucementJSON != nil {
            startAutoScroll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Updater.showUpdateAlert()
        print("HOME \(Constants.GlobalVariables.userID)")
        self.navigationController?.setStatusBarColor(backgroundColor: .white)
        
        myScrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        announcementCollectionView.delegate = self
        announcementCollectionView.dataSource = self
        
        announcementPageControl.currentPage = 0
        if #available(iOS 14.0, *) {
            //announcementPageControl.preferredIndicatorImage = UIImage(named: "page_dot_empty")
            //announcementPageControl.setIndicatorImage(UIImage(named: "page_dot_fill"), forPage: startPage)
        }
        
        mainBtn.imageView!.contentMode = .scaleAspectFit
        
        loadHome()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopAutoScroll()
    }
    
    func loadHome() {
        let parameters:Parameters = ["user_id":Constants.GlobalVariables.userID]
        loadRequest(method:.get, apiName:"getHome", authorization:true, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(_):
                break

            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS HOME\(json)")
                
                Constants.GlobalVariables.mainJSON = json["data"]
                self.annoucementJSON = json["data"]["slides"]
                self.announcementCollectionView.reloadData()
                
                self.mainBtn.sd_setImage(with: URL(string:json["data"]["image_buy"].stringValue), for: .normal, placeholderImage: nil)
                
                self.setupSlide()
            }
        }
    }
    
    func setupSlide() {
        stopAutoScroll()
        //annoucementJSON = JSON(["","","","",""])
        
        if self.annoucementJSON!.count > 0 {
            startAutoScroll()
            announcementPageControl.numberOfPages = annoucementJSON!.count
            if firstTime {
                self.announcementCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                firstTime = false
            }
            announcementPageControl.isHidden = false
        }
    }
    
    @IBAction func sideMenuShow(_ sender: UIButton) {
        self.sideMenuController!.revealMenu()
    }
    
    @IBAction func bannerClick(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == announcementCollectionView && annoucementJSON != nil {
            return annoucementJSON!.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == announcementCollectionView {
            
            let cellArray = self.annoucementJSON![indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"BasicCollectionCell", for: indexPath) as! BasicCollectionCell
            
            
            cell.cellImage.sd_setImage(with: URL(string:cellArray["slide_cover_image"].stringValue), placeholderImage: nil)
            //cell.cellImage.image = UIImage(named: "demo_home1")
            //cell.cellImage.setImageColor(color: .red)
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = collectionView.frame.width-30
        let viewHeight = viewWidth
        //viewHeight*2.33
        
        if collectionView == announcementCollectionView {//Category
            return CGSize(width: viewWidth , height: viewHeight)
        }else {
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == announcementCollectionView {//Category
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //.zero
        }else {
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == announcementCollectionView {//Category
            return 10
        }else {
            return CGFloat()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        vc.annoucementJSON = annoucementJSON![indexPath.row]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @objc func startAutoScroll() {
        announcementTimer?.invalidate()
        announcementTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.autoScrollAnnouncement), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll() {
        announcementTimer?.invalidate()
    }
    
    @objc func autoScrollAnnouncement() {
        print("auto")
        if announcementIndex < announcementCollectionView.numberOfItems(inSection: 0)-1 {
            announcementIndex += 1
        }
        else{
            announcementIndex = 0
        }
        let indexPath = IndexPath(item: announcementIndex, section: 0)
        self.announcementCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 2{
            let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
            announcementPageControl.currentPage = Int(pageIndex)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 2{
            stopAutoScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        for cell in announcementCollectionView.visibleCells {
//            let indexPath = announcementCollectionView.indexPath(for: cell)
//            print(indexPath)
//        }
        if scrollView.tag == 2{
            let visibleCells = announcementCollectionView.indexPathsForVisibleItems.sorted()
            var indexPath:IndexPath?
            
            if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
                print("left")
                indexPath = visibleCells.first
            } else {
                print("right")
                indexPath = visibleCells.last
            }
            
            announcementIndex = indexPath!.row
            self.announcementCollectionView.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
            
            perform(#selector(startAutoScroll), with: nil, afterDelay: 4)
        }
    }
}
