//
//  TextQuestionCell.swift
//  Rafup
//
//  Created by Ashish on 17/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class TextQuestionCell: UITableViewCell {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var questionMarkImageVw: UIImageView!
    
    @IBOutlet weak var lblScrollViewIndicator: UILabel!
    // MARK: -  Variable Declaration.
    
     // MARK: -  Cell Override Methods.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
