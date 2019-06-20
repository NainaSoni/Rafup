//
//  SideMenuCell.swift
//  Underwrite-it
//
//  Created by Ashish on 14/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var sideVw: UIView!
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    let selectedCellColour      = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.6037564212)
    let unSelectedCellColour    = UIColor.clear
    let selectedColour          = #colorLiteral(red: 0.8980392157, green: 0.7490196078, blue: 0.06274509804, alpha: 1)
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: -  Selected state cell Method.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

