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
        self.reposTableView.isHidden = true
        self.reposTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    //MARK:- Functions
    func updateDataSource(){
        
        self.dataSource = repoTableViewDataSource(cellIdentifier: "SearchTableViewCell", items: self.viewModel.repoData, configureCell: { (cell, evm) in
            cell.nameLabel.text = evm.name
        })
        
        DispatchQueue.main.async {
            self.reposTableView.dataSource = self.dataSource
            self.reposTableView.reloadData()
        }
    }
}

//MARK:- UISearchBarDelegate
extension ViewController :UISearchBarDelegate{
    
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
            self.viewModel.callFuncToGetEmpData(q: searchBar.text ?? "", page: 1)
            self.viewModel.bindRepoViewModelToController = {
                self.updateDataSource()
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

