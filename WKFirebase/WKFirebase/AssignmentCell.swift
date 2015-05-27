//
//  AssignmentCell.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/12/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class AssignmentCell: UITableViewCell {


    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var roleName: UILabel!
    
    @IBOutlet weak var checkbox: Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
