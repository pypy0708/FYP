//
//  DeliverymanOrderTableViewCell.swift
//  FYP
//
//  Created by yoshi on 24/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class DeliverymanOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    @IBOutlet weak var customerIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
