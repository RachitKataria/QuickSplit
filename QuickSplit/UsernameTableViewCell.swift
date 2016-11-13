//
//  UsernameTableViewCell.swift
//  QuickSplit
//
//  Created by Rachit K on 11/13/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

class UsernameTableViewCell: UITableViewCell {

    @IBOutlet weak var segueButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        alpha = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didClickSegueButton(_ sender: Any) {
    }

}
