//
//  ViewControllerExtension.swift
//  GitHubRepoSearch_Nspira
//
//  Created by HTS on 26/11/21.
//

import Foundation
import UIKit
extension UIViewController {
    func showNetworkerrorMessage(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { ok in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}
