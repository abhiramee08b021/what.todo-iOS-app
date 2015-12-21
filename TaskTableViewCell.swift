//
//  TaskTableViewCell.swift
//  what.todo
//
//  Created by abhiram moturi on 12/19/15.
//  Copyright © 2015 abhiram moturi. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    //MARK IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    //MARK methods
    func doneButtonTapped(sender: UIButton){
        print("done tapped for \(sender.tag)")
    }
    
}
