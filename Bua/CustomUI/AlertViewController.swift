//
//  AlertViewController.swift
//  Saw Grow
//
//  Created by Truk Karawawattana on 30/3/2566 BE.
//

import UIKit

class AlertViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var alertTitle = String()
    var alertBody = String()
    var actionButtonTitle = String()
    
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        titleLabel.text = alertTitle
        bodyLabel.text = alertBody
        actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        dismiss(animated: true)
        
        buttonAction?()
    }
}
