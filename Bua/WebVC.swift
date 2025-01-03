//
//  WebVC.swift
//  Bua
//
//  Created by Truk Karawawattana on 25/3/2567 BE.
//

import UIKit
import ProgressHUD
import WebKit
import Photos

class WebVC: UIViewController, WKNavigationDelegate {
    
    var titleString:String?
    var webUrlString:String?
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WEB = \(String(describing: webUrlString))")
        
        headerTitle.text = titleString
        
        let url = URL(string: webUrlString!)!
        //let url = URL(string: "https://rmcec.asiacement.co.th/payment/QR_CODE?amount=25707.82&order_id=2400105&sap_so=1311181983&sold_to_code=00000024&type=1&delivery_date=2024-11-20%2000:00:00.000")!
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
        print(urlAsString)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

