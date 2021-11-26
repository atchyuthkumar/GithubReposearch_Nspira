//
//  ViewController.swift
//  GitHubRepoSearch_Nspira
//
//  Created by HTS on 25/11/21.
//

import UIKit

class ViewController: UIViewController {

    // Outlet Connections
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var reposTableView: UITableView!
    
    // Variable Definitions
    private var viewModel: RepoListViewModel!
    private var dataSource : repoTableViewDataSource<RepoListTableViewCell,Repo>!
    var currentNoOfPerPage : Int = 10
    var isLoadingList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.reposTableView.isHidden = true
        self.reposTableView.register(UINib(nibName: "RepoListTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoListTableViewCell")
        
        if (!Reachability.isConnectedToNetwork()) {
            
            if (UserDefaults.standard.value(forKey: "offline_Data") != nil) {
                if let emptyData = UserDefaults.standard.value(forKey: "offline_Data") as? [Repo] {
                  //  self.viewModel.repoData = emptyData
                }
            }
        }
    }
    
    //MARK:- Functions
    func updateDataSource(){
        
//        if (UserDefaults.standard.value(forKey: "offline_Data") != nil) {
//            
//        } else {
//            let emptyData = self.viewModel.repoData! as! NSArray
//            UserDefaults.standard.set(emptyData, forKey: "offline_Data")
//            UserDefaults.standard.synchronize()
//        }
       
        
        self.dataSource = repoTableViewDataSource(cellIdentifier: "RepoListTableViewCell", items: self.viewModel.repoData, configureCell: { (cell, evm) in
            cell.nameLabel.text = evm.name
        })
        
        DispatchQueue.main.async {
            self.reposTableView.dataSource = self.dataSource
            self.reposTableView.delegate = self
            self.reposTableView.reloadData()
        }
    }
    
    
}

//MARK:- UISearchBarDelegate
extension ViewController :UISearchBarDelegate, UITableViewDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.resignFirstResponder()
            self.searchBar.text = ""
            self.reposTableView.isHidden = true
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.reposTableView.isHidden = false
        searchBar.resignFirstResponder()
        if searchBar.text != "" {
            viewModel = RepoListViewModel()
            if (Reachability.isConnectedToNetwork()) {
                self.viewModel.callFuncToGetEmpData(q: searchBar.text ?? "", page: 1)
                self.viewModel.bindRepoViewModelToController = {
                    self.updateDataSource()
                }
            } else {
                self.showNetworkerrorMessage(title: "No internet connection", message: "internet connection is not avialbel, please connect ")
         }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.reposTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepoDetailsViewController") as! RepoDetailsViewController
        if let description = self.viewModel.repoData[indexPath.row].itemDescription as? String {
            vc.itemDescription = description
        } else {
            vc.itemDescription = ""
        }
        vc.viewModel = RepoDetailsViewModel(item: self.viewModel.repoData[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.currentNoOfPerPage += 1
            self.viewModel.callFuncToGetEmpData(q: searchBar.text ?? "", page: currentNoOfPerPage)
            self.viewModel.bindRepoViewModelToController = {
                self.isLoadingList = false
                self.updateDataSource()
            }
        }
    }
    
}

