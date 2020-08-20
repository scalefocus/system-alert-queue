//
//  AlertManager.swift
//  MLiTP
//
//  Created by Plamen Penchev on 17.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

open class AlertFactoryManager {
    
    // MARK: - Singleton
    public static let shared = AlertFactoryManager()
    private init() {}
    
    // MARK: - Alert Presentation Logic
    
    /// Add alert with actions to the queue and present it in separate window.
    ///
    /// - Parameters:
    ///   - message: alert message
    ///   - title: alert title
    ///   - preferredStyle: Style of the alert controller. `.alert` by default.
    ///   - priority: priority (by default it's 0)
    ///   - withActions: UIalert actions
    ///   - textFieldsAttributes: Optional textFields' attributes
    @discardableResult
    open func presentActionAlert(withMessage message: String?,
                                 title: String?,
                                 preferredStyle: UIAlertController.Style = .alert,
                                 priority: Int = 0,
                                 withActions: [UIAlertAction],
                                 textFieldsAttributes: [TextFieldAttributes]? = nil) -> UIAlertController {
        let alert = UIAlertControllerInWindow(title: title,
                                              message: message,
                                              preferredStyle: preferredStyle,
                                              priority: priority)
        if let textFieldsAttributes = textFieldsAttributes {
            for textFieldAttributes in textFieldsAttributes {
                alert.addTextField { textfield in
                    textfield.attributedText = textFieldAttributes.attributedText
                    textfield.attributedPlaceholder = textFieldAttributes.attributedPlaceholder
                    textfield.tag = textFieldAttributes.tag
                    textfield.keyboardType = textFieldAttributes.keyboardType
                    textfield.returnKeyType = textFieldAttributes.returnKeyType
                    textfield.delegate = textFieldAttributes.delegate
                }
            }
        }
        
        withActions.forEach { alert.addAction($0) }
        insertAlert(alert)
        return alert
    }
    
    /// Adds simple alert with ok action to the queue and presents it in separate window.
    ///
    /// - Parameters:
    ///   - message: alert message
    ///   - title: alert title
    ///   - preferredStyle: Style of the alert controller. `.alert` by default.
    ///   - priority: priority (by default it's 0)
    ///   - alertActionTitle: String title of the "ok" alert action.
    @discardableResult
    open func presentSimpleAlert(withMessage message: String?,
                                 title: String?,
                                 preferredStyle: UIAlertController.Style = .alert,
                                 priority: Int = 0,
                                 alertActionTitle: String = Constants.ActionTitles.ok) -> UIAlertController {
        
        let action = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        return presentActionAlert(withMessage: message,
                                  title: title,
                                  preferredStyle: preferredStyle,
                                  priority: priority,
                                  withActions: [action])
    }
    
    /// Adds alert with retry block to the queue and presents it in separate window.
    ///
    /// - Parameters:
    ///   - message: alert message
    ///   - title: alert title
    ///   - preferredStyle: Style of the alert controller. `.alert` by default.
    ///   - priority: priority (by default it's 0)
    ///   - retryBlock: the block to be executed when retry is tapped
    ///   - cancelBlock: the block to be executed on cancel
    ///   - retryActionTitle: String title of the "retry" alert action.
    ///   - cancelActionTitle: String title of the "cancel" alert action.
    @discardableResult
    open func presentRetryAlert(withMessage message: String?,
                                title: String?,
                                preferredStyle: UIAlertController.Style = .alert,
                                priority: Int = 0,
                                retryBlock: (() -> Void)?,
                                cancelBlock: (() -> Void)? = nil,
                                retryActionTitle: String = Constants.ActionTitles.retry,
                                cancelActionTitle: String = Constants.ActionTitles.cancel) -> UIAlertController {
        
        let retryAction = UIAlertAction(title: retryActionTitle, style: .default, handler: { (_) in
            retryBlock?()
        })
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: { (_) in
            cancelBlock?()
        })
        
        return presentActionAlert(withMessage: message,
                                  title: title,
                                  preferredStyle: preferredStyle,
                                  priority: priority,
                                  withActions: [retryAction, cancelAction])
    }
    
    // MARK: - Alert Management
    open func didDismissAlert() {
        isAlertPresented = false
        showFirstInQueue()
    }
    
    private var isAlertPresented = false
    
    private var alertQueue: [UIAlertControllerInWindow] = [] {
        didSet {
            showFirstInQueue()
        }
    }
    
    /// Checks if there's no presented alert and if the queue is not empty shows next
    private func showFirstInQueue() {
        if !isAlertPresented,
            !alertQueue.isEmpty {
            isAlertPresented = true
            alertQueue.first?.show()
            alertQueue.removeFirst()
        }
    }
    
    private func insertAlert(_ alert: UIAlertControllerInWindow) {
        guard alert.priority != 0, !alertQueue.isEmpty else {
            alertQueue.append(alert)
            return
        }
        
        for index in 0...alertQueue.count - 1 {
            if alertQueue[index].priority < alert.priority {
                alertQueue.insert(alert, at: index)
                break
            } else if index == alertQueue.count - 1 {
                alertQueue.append(alert)
            }
        }
    }
    
}

/// Attributes to add in an alert's textField
public struct TextFieldAttributes {
    
    /// Attributed text used to write in the textField
    public let attributedText: NSAttributedString
    
    /// Attributed placeholder shown when the textField is empty
    public let attributedPlaceholder: NSAttributedString
    
    /// Unique tag to separate different textFields in case of multiple ones in a single alert
    public let tag: Int
    
    /// The type of keyboard that will be shown when writing in the specified textField
    public let keyboardType: UIKeyboardType
    
    /// The keyboard's return button type
    public let returnKeyType: UIReturnKeyType
    
    /// The textField's delegate
    public weak var delegate: UITextFieldDelegate?
    
    public init(attributedText: NSAttributedString,
                attributedPlaceholder: NSAttributedString,
                tag: Int = 0,
                keyboardType: UIKeyboardType = .default,
                returnKeyType: UIReturnKeyType = .default) {
        self.attributedText = attributedText
        self.attributedPlaceholder = attributedPlaceholder
        self.tag = tag
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
    }
}
