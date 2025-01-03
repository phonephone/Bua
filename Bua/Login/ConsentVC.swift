//
//  ConsentVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import SwiftyJSON
import ProgressHUD
import WebKit

enum ConsentMode {
    case term
    case privacy
}

class ConsentVC: UIViewController, WKNavigationDelegate {
    
    var masterJSON:JSON?
    
    var consentMode: ConsentMode?
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CONSENT")
        
        var url = URL(string: "")
        
        switch consentMode {
        case .term:
            headerTitle.text = "เงื่อนไขการใช้งาน"
            url = URL(string: masterJSON!["link_terms_of_use"].stringValue)
            //URL(string: "https://rmcec.asiacement.co.th/terms-of-use")
            
        case .privacy:
            headerTitle.text = "นโยบายความเป็นส่วนตัว"
            url = URL(string: masterJSON!["link_privacy_policy"].stringValue)
            //URL(string: "https://rmcec.asiacement.co.th/privacy-policy")
            
        case nil:
            break
        }
        
        myWebView.load(URLRequest(url: url!))
        //myWebView.loadHTMLString("", baseURL: nil)
        myWebView.navigationDelegate = self
        myWebView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let urlAsString = navigationAction.request.url?.absoluteString.lowercased() else {
            return
        }
        
//        if urlAsString.range(of:"someStr") != nil {
//            // do something
//        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
