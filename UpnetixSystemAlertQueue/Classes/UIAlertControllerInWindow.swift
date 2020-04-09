//
//  UIAlertControllerInWindow.swift
//  MLiTP
//
//  Created by Plamen Penchev on 17.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

/*!
 * Subclass of UIAlertController allowing to show alert without parent view
 * controller. Does this by creating transparent key window and placing the
 * alert on it. Do not overuse - meant only for the cases when you simply
 * cannot present a normal UIAlertController. Overusing in some very rare edge
 * cases could lead to inability to navigate and multiple alerts shown over
 * each other.
 */
open class UIAlertControllerInWindow: UIAlertController {
    
    lazy var alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = StatusBarViewController()
        window.backgroundColor = UIColor.clear
        if #available(iOS 13.0, *) {
            window.windowScene = UIApplication.shared.keyWindow?.windowScene
        }
        return window
    }()
    
    open var priority: Int = 0
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AlertFactoryManager.shared.didDismissAlert()
    }
    
    convenience init(title: String?,
                     message: String?,
                     preferredStyle: UIAlertController.Style,
                     priority: Int) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.priority = priority
    }
    
    open func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let rootViewController = alertWindow.rootViewController {
            alertWindow.makeKeyAndVisible()
            
            popoverPresentationController?.sourceView = rootViewController.view
            popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
            popoverPresentationController?.permittedArrowDirections = []
            
            rootViewController.present(self, animated: animated, completion: completion)
        }
    }
    
    open func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        alertWindow.isHidden = true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let orientations = UIApplication.shared.delegate?.application?(UIApplication.shared, supportedInterfaceOrientationsFor: alertWindow) else {
            return UIInterfaceOrientationMask.portrait
        }
        
        return orientations
    }
    
    override open var shouldAutorotate: Bool {
        return true
    }
}

private class StatusBarViewController: UIViewController {
    
    fileprivate override var preferredStatusBarStyle: UIStatusBarStyle {
        guard #available(iOS 13, *),
            let barStyle = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarStyle else {
                return UIApplication.shared.statusBarStyle
        }
        
        return barStyle
    }
    
    fileprivate override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}
