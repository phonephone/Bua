
//
//  Tab3VC.swift
//  Bua
//
//  Created by Truk Karawawattana on 7/10/2567 BE.
//

import UIKit
import ProgressHUD
import WebKit

class Tab3VC: UIViewController, WKNavigationDelegate {
    
    var webUrlString:String?
    
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webUrlString = Constants.GlobalVariables.mainJSON?["link_menu"]["menu3"].stringValue
        print("TAB3 = \(String(describing: webUrlString))")
        
        let url = URL(string: webUrlString!)!
        //let url = URL(string: "https://www.google.com")!
        myWebView.load(URLRequest(url: url))
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
    
    @IBAction func sideMenuShow(_ sender: UIButton) {
        self.sideMenuController!.revealMenu()
    }
}

