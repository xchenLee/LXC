//
//  IImageAlbumCell.swift
//  LXC
//
//  Created by renren on 16/3/26.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class IImageAlbumCell: UITableViewCell {

    
    @IBOutlet weak var imageViewThr: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewOne: UIImageView!
    
    
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var photosCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
