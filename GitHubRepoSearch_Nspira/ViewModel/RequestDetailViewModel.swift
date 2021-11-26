//
//  RequestDetailViewModel.swift
//  GitHubRepoSearch_Nspira
//
//  Created by HTS on 26/11/21.
//

import Foundation
class RepoDetailsViewModel
{
    var selectedRepo : Repo
    
    private var conytributorsApiService : ContributorsAPI!
    
    init(item: Repo) {
        selectedRepo = item
        self.conytributorsApiService =  ContributorsAPI()
        callFuncToGetContributorsData()
    }
    private(set) var contributorsData : [ContributorModel]! {
        didSet {
            self.bindContributorViewModelToController()
        }
    }
    
    var bindContributorViewModelToController : (() -> ()) = {}
    
    func callFuncToGetContributorsData() {
        self.conytributorsApiService.getContributors(url: selectedRepo.contributorsURL ?? "") { contributors, error in
            self.contributorsData = contributors
        }
    }
}

public class ContributorsAPI: GithubService {
    
    func getContributors(url: String, completion: @escaping ([ContributorModel]?, Error?) -> Swift.Void) {
        self.gt_get(path: url, completion: completion)
    }
    
}
