//
//  DetailViewController.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    var selectedItem : ImageVideosDetailModel!
    var imageVideoList : [ImageVideosDetailModel]!
    fileprivate let collectionViewWidth = (UIScreen.main.bounds.width-5)/3 - 10
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        
        self.setupSelectedItem(items: selectedItem)
        if imageVideoList.count > 0 {
            detailCollectionView.reloadData()
        }
        
        messageLabel.text = "Video content ... comming Soon.."
        messageLabel.textColor = .red
    }


    
    func setupSelectedItem(items:ImageVideosDetailModel ){
        if items.isVideo{
            displayImageView.isHidden = true
            messageLabel.isHidden = false
            self.setupNavigatonBarTitle(title: "Video")
            print("This is a video")
        }
        else{
            print("This is an image")
            messageLabel.isHidden = true
            self.setupNavigatonBarTitle(title: "Image")
            displayImageView.isHidden = false
            if let url = items.url{
                displayImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
            }
            else{
                displayImageView.image = UIImage(named: "placeholder")
            }
        
            displayImageView.contentMode = .scaleAspectFit
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupNavigatonBarTitle(title: String){
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.red]
    }

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageVideoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.detailCollectionCellIdentifier, for: indexPath) as! DetailCollectionViewCell
        if let data = imageVideoList?[indexPath.item] {
            cell.configureData(items: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedImageVideo = imageVideoList?[indexPath.item] else{return}
        
        self.setupSelectedItem(items: selectedImageVideo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let cellSize :CGSize = CGSize(width: collectionViewWidth, height: collectionViewWidth + 20)
        
        return cellSize
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
}
