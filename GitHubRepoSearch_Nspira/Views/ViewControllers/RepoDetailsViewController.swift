//
//  RepoDetailsViewController.swift
//  GitHubRepoSearch_Nspira
//
//  Created by HTS on 26/11/21.
//

import UIKit

class RepoDetailsViewController: UIViewController {
    
    //Variable definitions
    var viewModel: RepoDetailsViewModel!
    private var dataSource : RepoContributorsDataSource<RepoListTableViewCell,ContributorModel>!
    var itemDescription = String()
    
    //Outlet connections
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var btnOfProjectLink: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var contributorsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repo Details"
        self.contributorsTableView.register(UINib(nibName: "RepoListTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoListTableViewCell")
        bindData()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        
        self.viewModel.bindContributorViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        
        self.dataSource = RepoContributorsDataSource(cellIdentifier: "RepoListTableViewCell", items: self.viewModel.contributorsData, configureCell: { (cell, evm) in
            cell.nameLabel.text = evm.login
        })
        
        DispatchQueue.main.async {
            self.contributorsTableView.dataSource = self.dataSource
            self.contributorsTableView.reloadData()
        }
    }
    
    func bindData() {
        self.avatarImageView.downloaded(from: self.viewModel.selectedRepo.owner?.avatarURL ?? "")
        self.nameLabel.text = self.viewModel.selectedRepo.owner?.login
        self.btnOfProjectLink.setTitle(self.viewModel.selectedRepo.url, for: .normal)
        if (itemDescription == "") {
            self.descTextView.isHidden = true
        } else {
            self.descTextView.isHidden = false
            self.descTextView.text = itemDescription
        }
    }
    
    @IBAction func onClickProjectLink(_ sender: UIButton) {
        if let url = URL(string: self.viewModel.selectedRepo.htmlURL ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
