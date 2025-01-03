//
//  MyCell.swift
//  Saw Grow
//
//  Created by Truk Karawawattana on 5/11/2564 BE.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var menuTitle: UILabel!
    @IBOutlet var menuAlert: UILabel!
    @IBOutlet var menuSwitch: UISwitch!
    @IBOutlet var menuArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        self.backgroundColor = .clear
        
        // Title
        //self.menuTitle.textColor = .white
    }
}

class ProfileCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var profileTitle: UILabel!
    @IBOutlet var profileDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        self.backgroundColor = .clear
    }
}

class BasicCollectionCell: UICollectionViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellTitle2: UILabel!
    @IBOutlet var cellDescription: UILabel!
    @IBOutlet var cellDescription2: UILabel!
    @IBOutlet var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        self.backgroundColor = .clear
    }
}

class BasicCollectionCell_Header: UICollectionReusableView {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellTitle2: UILabel!
    @IBOutlet var cellDescription: UILabel!
    @IBOutlet var cellDescription2: UILabel!
    @IBOutlet var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
