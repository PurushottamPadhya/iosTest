//
//  SearchViewController.swift
//  iosTest
//
//  Created by Purushottam on 4/28/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import ObjectMapper


protocol SearchDelegate  : class {
    
    func searchSucessWithData(item: ImageVideosDetailModel, itemList: [ImageVideosDetailModel])
    func searchDismiss()
    
}
class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTableBottomConstraint: NSLayoutConstraint!
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchList: [ImageVideosDetailModel]?
    weak var delegate : SearchDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorColor = .clear
        setupSearchController()

    }
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search your keys"
        searchController.delegate = self
        searchController.searchBar.showsCancelButton = true
        self.searchController.searchBar.delegate = self
        searchController.isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {

       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    


    @objc func dismissView() {
        self.dismiss(animated: false, completion: nil)
    }

    func searchYourKey(_ isShowProgressHud : Bool, key: String){
        let parameter :[String: AnyObject] = ["query": key as AnyObject]
            
        APIManager.init(.withoutHeader, urlString: EndPoints.searchAPI.url,parameters:parameter , method: .get).handleResponse(viewController: self, loadingOnView: self.view, withLoadingColor: .gray, isShowProgressHud: isShowProgressHud, isShowNoNetBanner: true, isShowAlertBanner: false, completionHandler: { [weak self](data) in
            guard let strongSelf = self else {return}
            
            guard let data = data as? [String: Any], data.count > 0  else {
                // empty data
                
                return
            }
            if let imageResponse = Mapper<ImageVideosListModel>().map(JSON: data){
                if let imageList = imageResponse.images,imageList.count > 0 {
                    strongSelf.searchList = imageList
                    self?.searchTableView.reloadData()
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
    

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: - table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.searchTableCellIdentifier, for: indexPath) as! SearchTableViewCell
        
        if let data = searchList?[indexPath.item] {
            cell.configureData(items: data)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedImageVideo = searchList?[indexPath.item] else{return}
        self.searchController.isActive = false
        self.dismiss(animated: false) {
            self.delegate?.searchSucessWithData(item: selectedImageVideo, itemList: self.searchList!)
            self.searchController.dismiss(animated: false, completion: {
                print("dismiss both controller in search")
            })
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
}


extension SearchViewController : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating{
   
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.isActive = true
       
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
             self.searchYourKey(true, key: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        self.delegate?.searchDismiss()
        searchBar.text = ""
        self.dismiss(animated: false, completion: nil)
        
    }
}



