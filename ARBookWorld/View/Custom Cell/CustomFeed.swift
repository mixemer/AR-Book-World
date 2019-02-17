//
//  CustomFeed.swift
//  ARBookWorld
//
//  Created by Mehmet Sahin on 2/16/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit

class CustomFeed: UITableViewCell {

    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
