//
//  ViewController.swift
//  UpnetixSystemAlertQueueExample
//
//  Created by Dimitar V. Petrov on 21.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import UpnetixSystemAlertQueue

class ViewController: UIViewController {

    @IBAction func didTapOnSimpleAlertButton(_ sender: Any) {
        AlertFactoryManager.shared.presentSimpleAlert(withMessage: "Hello, I am SimpleAlert!", title: nil)
    }
    
    @IBAction func didTapOnRetryAlertButton(_ sender: Any) {
        AlertFactoryManager.shared.presentRetryAlert(withMessage: "Hello, I am RetryAlert!",
                                                     title: nil,
                                                     retryBlock: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didTapOnRetryAlertButton(strongSelf)
        })
    }
    
    @IBAction func didTapOnCustomAlertButton(_ sender: Any) {
        let `default` = UIAlertAction(title: "Default", style: .default, handler: nil)
        let destructive = UIAlertAction(title: "Destructive", style: .destructive, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertFactoryManager.shared.presentActionAlert(withMessage: "Hello, I am ActionAlert!",
                                                      title: nil,
                                                      withActions: [`default`, destructive, cancel])
    }
    
}
