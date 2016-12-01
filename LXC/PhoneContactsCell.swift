//
//  PhoneContactsCell.swift
//  LXC
//
//  Created by renren on 16/3/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class PhoneContactsCell: UITableViewCell {

    @IBOutlet weak var headView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
