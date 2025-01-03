//
//  Extension_UI.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import Foundation
import UIKit
import ProgressHUD

// MARK: - UIView
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.layer.mask = mask
    }
    
    func setGradientBackground(colorTop: UIColor? = nil, colorBottom: UIColor? = nil, mainPage: Bool? = false){
        
        for sublayer in self.layer.sublayers! {
            if sublayer.name == "GRADIENT" {
                sublayer.removeFromSuperlayer()
            }
        }
        
        if colorTop != nil && colorBottom != nil {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorBottom!.cgColor, colorTop!.cgColor]
            
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
            gradientLayer.frame = self.bounds
            gradientLayer.name = "GRADIENT"
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

// MARK: - UIImageView
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}

// MARK: - UIImage
extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
}

// MARK: - UILabel
extension UILabel{
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.string.count))
        self.attributedText = attributedString
    }
}

// MARK: - UIButton
extension UIButton {
    func disableBtn() {
        isEnabled = false
        backgroundColor = .btnDisable
        setTitleColor(.lightGray, for: .normal)
    }
    
    func enableBtn() {
        isEnabled = true
        backgroundColor = .mainTheme
        setTitleColor(.white, for: .normal)
    }
    
    func disableIconBtn() {
        isEnabled = false
        setTitleColor(.lightGray, for: .normal)
    }
    
    func enableIconBtn() {
        isEnabled = true
        setTitleColor(.mainTheme, for: .normal)
    }
    
    func checkboxEnable(_ on:Bool) {
        isUserInteractionEnabled = true
        if on {
            setImage(Constants.Image.checkboxOn, for: .normal)
        }
        else {
            setImage(Constants.Image.checkboxOff, for: .normal)
        }
    }
    
    func checkboxDisable(_ on:Bool) {
        isUserInteractionEnabled = false
        if on {
            setImage(Constants.Image.checkboxDisableOn, for: .normal)
        }
        else {
            setImage(Constants.Image.checkboxDisableOff, for: .normal)
        }
    }
    
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: title(for: .normal) ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.string.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

// MARK: - UITextField
extension UITextField {
    func disableField() {
        isUserInteractionEnabled = false
        backgroundColor = .lightBg
        textColor = .mainTheme
    }
    
    func enableField() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        textColor = .black
    }
    
    func setUI () {
        self.borderStyle = .none
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addPlaceholderSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.placeholder ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.string.count))
        self.attributedPlaceholder = attributedString
    }
}

// MARK: - UICollectionViewCell
extension UICollectionViewCell {
    func setRoundAndShadow () {
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 0.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}

// MARK: - UIAlertController & UIAlertAction
extension UIAlertController {
    func setColorAndFont(){
        
        let attributesTitle = [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray, NSAttributedString.Key.font: UIFont.custom_Medium(ofSize: 18)]
        let attributesMessage = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.custom_Regular(ofSize: 15)]
        let attributedTitleText = NSAttributedString(string: self.title ?? "", attributes: attributesTitle as [NSAttributedString.Key : Any])
        let attributedMessageText = NSAttributedString(string: self.message ?? "", attributes: attributesMessage as [NSAttributedString.Key : Any])
        
        self.setValue(attributedTitleText, forKey: "attributedTitle")
        self.setValue(attributedMessageText, forKey: "attributedMessage")
    }
}

// MARK: - UIAlertAction
extension UIAlertAction {
    var titleTextColor: UIColor? {
        get { return self.value(forKey: "titleTextColor") as? UIColor }
        set { self.setValue(newValue, forKey: "titleTextColor") }
    }
}

// MARK: - UIDevice
extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}

// MARK: - Color
extension UIColor {
    static func colorFromRGB(rgbString : String) -> UIColor{
        let rgbArray = rgbString.components(separatedBy: ",")
        
        if rgbArray.count == 3 {
            let red = Float(rgbArray[0])!
            let green = Float(rgbArray[1])!
            let blue = Float(rgbArray[2])!
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1.0)
            return color
        }
        else {
            return .textGray
        }
    }
    
    func colorFromHex (hexString:String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
