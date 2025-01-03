//
//  Extension_HTTP.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import Foundation
import Alamofire
import SwiftyJSON
import ProgressHUD

// MARK: - HTTPHeaders
extension HTTPHeaders {
    static let header = ["Accept": "application/json"] as HTTPHeaders
    
    static let headerWithAuthorize = ["Authorization": PlistParser.getKeysValue()!["apiBearer"]!, "Accept": "application/json"] as HTTPHeaders
    
    //static let headerWithAuthorize = ["Authorization": "Bearer xxx", "Accept": "application/json"] as HTTPHeaders
}

// MARK: - UIViewController
extension UIViewController {
    func loadRequest(method:HTTPMethod, apiName:String, authorization:Bool, showLoadingHUD:Bool, dismissHUD:Bool, parameters:Parameters, completion: @escaping (AFResult<AnyObject>) -> Void) {
        
        if showLoadingHUD == true
        {
            showLoading()
        }
        
        let fullURL = Constants.API.apiURL+apiName
        
        var headers: HTTPHeaders
        if authorization == true {
            //let accessToken = UserDefaults.standard.string(forKey:"access_token")
            headers = HTTPHeaders.headerWithAuthorize
        }
        else{
            headers = HTTPHeaders.header
        }
        //print("HEADER = \(headers)")
        //print("PARAM = \(parameters)")
        
        AF.request(fullURL,
                   method: method,
                   parameters: parameters,
                   //encoding: JSONEncoding.default,
                   headers: headers,
                   requestModifier: { $0.timeoutInterval = 60 }
        ).responseJSON { response in
            
            //debugPrint(response)
            
            switch response.result {
            case .success(let data as AnyObject):
                
                let json = JSON(data)
                if json["status"] == 200 {
                    if showLoadingHUD == true && dismissHUD == true
                    {
                        ProgressHUD.dismiss()
                    }
                    completion(.success(data))
                }
                else{
                    self.showError(withText:json["message"].stringValue)
                }
                
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
                completion(.failure(error))
                
            default:
                fatalError("received non-dictionary JSON response")
            }
        }
    }
    
    func showLoading(withText:String? = Constants.HUD.loadingText) {
        //ProgressHUD.show(Constants.HUD.loadingText, interaction: false)
        ProgressHUD.show(withText, interaction: false)
    }
    
    func showSubmitSuccess(withText:String? = Constants.HUD.successText, delay:TimeInterval = 2.0, completion: @escaping () -> Void = {}) {
        
        ProgressHUD.showSuccess(withText,delay: delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.2) {
            completion()
        }
    }
    
    func showError(withText:String? = Constants.HUD.errorText, delay:TimeInterval = 2.0, completion: @escaping () -> Void = {}) {
        
        ProgressHUD.showFailed(withText,delay: delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.2) {
            completion()
        }
    }
    
    func showErrorNoData(withText:String? = Constants.HUD.noDataText, delay:TimeInterval = 2.0, completion: @escaping () -> Void = {}) {
        
        ProgressHUD.showError(withText,delay: delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.2) {
            completion()
        }
    }
    
    func showComingSoon() {
        //ProgressHUD.imageError = UIImage(named:"coming_soon")!
        ProgressHUD.showError(Constants.HUD.comingSoonText)
    }
    
    func dateFromServerString(dateStr:String) -> Date? {
        if let dtDate = DateFormatter.serverFormatter.date(from: dateStr){
            return dtDate as Date?
        }
        return nil
    }
    
    func dateWithTimeFromServerString(dateStr:String) -> Date? {
        if let dtDate = DateFormatter.serverFormatterWithTime.date(from: dateStr){
            return dtDate as Date?
        }
        return nil
    }
    
    func dateToServerString(date:Date) -> String{
        let strdt = DateFormatter.serverFormatter.string(from: date)
        if let dtDate = DateFormatter.serverFormatter.date(from: strdt){
            return DateFormatter.serverFormatter.string(from: dtDate)
        }
        return "-"
    }
    
    func dateWithTimeToServerString(date:Date) -> String{
        let strdt = DateFormatter.serverFormatterWithTime.string(from: date)
        if let dtDate = DateFormatter.serverFormatterWithTime.date(from: strdt){
            return DateFormatter.serverFormatterWithTime.string(from: dtDate)
        }
        return "-"
    }
    
    func dateFromCustomString(dateStr:String, format:String) -> Date?{
        let dateFormatter:DateFormatter = DateFormatter.customFormatter
        dateFormatter.dateFormat = format
        if let dtDate = dateFormatter.date(from: dateStr){
            return dtDate as Date?
        }
        return nil
    }
    
    func stringFromCustomDate(date:Date, format:String) -> String{
        let dateFormatter:DateFormatter = DateFormatter.customFormatter
        dateFormatter.dateFormat = format
        let strdt = dateFormatter.string(from: date)
        if let dtDate = dateFormatter.date(from: strdt){
            return dateFormatter.string(from: dtDate)
        }
        return "-"
    }
}
