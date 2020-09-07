//
//  productListTableViewCell.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/6/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit

class productListTableViewCell: UITableViewCell {

    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var currUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
