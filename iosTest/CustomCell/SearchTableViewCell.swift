//
//  SearchTableViewCell.swift
//  iosTest
//
//  Created by Purushottam on 4/28/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var searchImageView: UIImageView!
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
            searchImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        }
        else{
            searchImageView.image = UIImage(named: "placeholder")
        }
        searchImageView.contentMode = .scaleAspectFit
        
        if let id = items.id {
            searchNameLabel.text = "product ID: \(id)"
        }
        else{
           searchNameLabel.text = ""
        }
    }
}
