//
//  SpecialTableViewCell.swift
//  mobilizer
//
//  Created by Connor on 6/15/16.
//  Copyright © 2016 Connor Kirk. All rights reserved.
//

import UIKit

class SpecialCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}