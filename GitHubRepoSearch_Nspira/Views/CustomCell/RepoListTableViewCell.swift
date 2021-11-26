//
//  RepoListTableViewCell.swift
//  GitHubRepoSearch_Nspira
//
//  Created by HTS on 26/11/21.
//

import UIKit

class RepoListTableViewCell: UITableViewCell {

    //Outlet Connections
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
