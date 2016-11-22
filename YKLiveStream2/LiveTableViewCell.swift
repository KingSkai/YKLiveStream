

//
//  LiveTableViewCell.swift
//  YKLiveStream2
//
//  Created by 王凯 on 2016/11/17.
//  Copyright © 2016年 王凯. All rights reserved.
//

import UIKit

class LiveTableViewCell: UITableViewCell {
    @IBOutlet weak var imgPor: UIImageView!
    @IBOutlet weak var labNick: UILabel!
    @IBOutlet weak var labAddr: UILabel!
    @IBOutlet weak var labViewers: UILabel!
    @IBOutlet weak var imgBigPor: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
