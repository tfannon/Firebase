//
//  WorkflowCell.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/14/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//


class WorkflowCell: UITableViewCell {
    @IBOutlet weak var stateIcon: UIImageView!
    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var newState: UILabel!
    @IBOutlet weak var previousState: UILabel!
    @IBOutlet weak var changedBy: UILabel!
}
