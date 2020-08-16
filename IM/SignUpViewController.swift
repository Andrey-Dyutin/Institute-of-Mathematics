//
//  SignUpViewController.swift
//  IM
//
//  Created by Андрей Дютин on 15.08.2020.
//  Copyright © 2020 Андрей Дютин. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseCore
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sing in
        view.addSubview(singInButton)
        setVisibleSingInButton(visible: false)
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.color = .black
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = singInButton.center
        view.addSubview(activityIndicator)
        // TextField
        userNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillApper),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    //MARK: - Sing in
    lazy var singInButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 120, height: 34)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 330)
        button.backgroundColor = .black
        button.setTitle("Sign un", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.alpha = 0.2
        button.addTarget(self, action: #selector(singIn), for: .touchUpInside)
        return button
    }()
    
    private func setVisibleSingInButton(visible: Bool) {
        if visible {
            singInButton.alpha = 1.0
            singInButton.isEnabled = true
        } else {
            singInButton.alpha = 0.2
            singInButton.isEnabled = false
        }
    }
    
    @objc func keyboardWillApper(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        singInButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 20.0 - singInButton.frame.height / 2)
        activityIndicator.center = singInButton.center
    }
    
    @objc private func singIn() {
        setVisibleSingInButton(visible: false)
        singInButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard
            let userName = userNameTextField.text,
            let login = loginTextField.text,
            let password = passwordTextField.text
            else { return }
        Auth.auth().createUser(withEmail: login, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.setVisibleSingInButton(visible: true)
                self.singInButton.setTitle("Sign un", for: .normal)
                self.activityIndicator.stopAnimating()
                return
            }
            print("User authentication was successful")
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = userName
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.setVisibleSingInButton(visible: true)
                        self.singInButton.setTitle("Sign un", for: .normal)
                        self.activityIndicator.stopAnimating()
                    }
                    print("ok")
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }
//            self.dismiss(animated: true)
        }
    }
    
    //MARK: - TextField
    @objc private func textFieldChanged() {
        guard
            let name = userNameTextField.text,
            let login = loginTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
            else { return }
        let contentField = !(name.isEmpty) && !(login.isEmpty) && !(password.isEmpty) &&
            confirmPassword == password
        setVisibleSingInButton(visible: contentField)
    }
    
}
