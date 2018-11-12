//
//  CategoryTableViewCell.swift
//  Sporting
//
//  Created by admin on 02/11/2018.
//  Copyright © 2018 multi. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellImage.layer.cornerRadius = 3
        cellImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
