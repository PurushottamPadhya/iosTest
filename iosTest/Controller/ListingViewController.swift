//
//  ListingViewController.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ListingViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var itemList: [ImageVideosDetailModel]? {
        didSet {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listTableView.separatorColor = .clear
        listTableView.delegate = self
        listTableView.dataSource = self
        self.getItemList(true)
    }

    func getItemList(_ isShowProgressHud : Bool){
        
        APIManager.init(.withoutHeader, urlString: EndPoints.listingAPI.url, method: .get).handleResponse(viewController: self, loadingOnView: self.view, withLoadingColor: .gray, isShowProgressHud: isShowProgressHud, isShowNoNetBanner: true, isShowAlertBanner: false, completionHandler: { [weak self](data) in
            guard let strongSelf = self else {return}
   
            guard let data = data as? [String: Any], data.count > 0  else {
                // empty data
                
                return
            }
            if let imageResponse = Mapper<ImageVideosListModel>().map(JSON: data){
                if let imageList = imageResponse.images,imageList.count > 0 {
                     strongSelf.itemList = imageList
                }
                // data not found
               
            }
            else{
                // error of mapping
            }
            
            
        }, errorBlock: { [weak self](error) in
            guard let _ = self else { return }
        }) { [weak self](failure) in
            guard let _ = self else { return }
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
    
    func setupNavigatonBar(){
        self.title = "Image Videos Listing"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "system", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.red]

        
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        let sb = UIStoryboard.init(name: StoryBoardName.main, bundle: nil)
        let searchVC = sb.instantiateViewController(withIdentifier: controllerIdentifier.searchVC) as? SearchViewController
        searchVC?.delegate = self
        searchVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.present(searchVC!, animated: false, completion: nil)
    }
    

}

extension ListingViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: - table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.listTableCellIdentifier, for: indexPath) as! ListTableViewCell
        
        if let data = itemList?[indexPath.item] {
            cell.configureData(items: data)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedImageVideo = itemList?[indexPath.item] else{return}
        let sb = UIStoryboard.init(name: StoryBoardName.main, bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: controllerIdentifier.detailVC) as? DetailViewController
        detailVC?.selectedItem = selectedImageVideo
        detailVC?.imageVideoList = itemList!
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
}

extension ListingViewController:SearchDelegate{
    func searchDismiss() {
        
    }
    func searchSucessWithData(item: ImageVideosDetailModel, itemList: [ImageVideosDetailModel]) {
        let sb = UIStoryboard.init(name: StoryBoardName.main, bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: controllerIdentifier.detailVC) as? DetailViewController
        detailVC?.selectedItem = item
        detailVC?.imageVideoList = itemList
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
    

    
    
}
