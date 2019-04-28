//
//  DetailCollectionViewCell.swift
//  iosTest
//
//  Created by Purushottam on 4/28/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    func configureData(items: ImageVideosDetailModel){
        if let url = items.url{
            itemImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        }
        else{
            itemImageView.image = UIImage(named: "placeholder")
        }
        itemImageView.contentMode = .scaleAspectFit
        itemNameLabel.text = items.id ?? ""
    }
}
