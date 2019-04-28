//
//  ListTableViewCell.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(items: ImageVideosDetailModel){
        if let url = items.url{
            itemImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        }
        else{
            itemImageView.image = UIImage(named: "placeholder")
        }
        itemImageView.contentMode = .scaleAspectFit
        
        if let id = items.id {
            itemNameLabel.text = "product ID: \(id)"
        }
        else{
            itemNameLabel.text = ""
        }
        
    }

}
