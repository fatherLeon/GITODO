//
//  UIViewController++Extension.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
}
