//
//  ViewController.swift
//  IM
//
//  Created by Андрей Дютин on 14.08.2020.
//  Copyright © 2020 Андрей Дютин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var imageViewLogotype: UIImageView!
    @IBOutlet weak var activityIndicatorImageViewLogotype: UIActivityIndicatorView!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Logotype
        activityIndicatorImageViewLogotype.color = .black
        activityIndicatorImageViewLogotype.isHidden = true
        activityIndicatorImageViewLogotype.hidesWhenStopped = true
        fetchImageLogotype()
        // Sing in
        view.addSubview(singInButton)
        setVisibleSingInButton(visible: false)
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.color = .black
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = singInButton.center
        view.addSubview(activityIndicator)
        // TextField
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillApper),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    //MARK: - Logotype
    func fetchImageLogotype(){
        activityIndicatorImageViewLogotype.isHidden = false
        activityIndicatorImageViewLogotype.startAnimating()
        guard let urlImageLogotype =
            URL(string:"https://kpfu.ru/docs/F51133905920/img1088461656.jpg") else { return }
        let session = URLSession.shared // https://kpfu.ru/docs/F58293241586/img1198266443.jpg
        session.dataTask(with: urlImageLogotype) { (data, response, error) in
            if let data = data,let imageLogotype = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.activityIndicatorImageViewLogotype.startAnimating()
                    self.activityIndicatorImageViewLogotype.isHidden = true
                    self.imageViewLogotype.image = imageLogotype
                }
            }
        }.resume()
    }
    
    //MARK: - Sing in
    lazy var singInButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 120, height: 34)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 330)
        button.backgroundColor = .black
        button.setTitle("Sign in", for: .normal)
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
            let login = loginTextField.text,
            let password = passwordTextField.text
            else { return }
        Auth.auth().signIn(withEmail: login, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.setVisibleSingInButton(visible: true)
                self.singInButton.setTitle("Sign in", for: .normal)
                self.activityIndicator.stopAnimating()
                return
            }
            print("Выполнен вход")
            self.presentingViewController?.dismiss(animated: true)
        }
        
    }
    //MARK: - TextField
    @objc private func textFieldChanged() {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
            else { return }
        let contentField = !(login.isEmpty) && !(password.isEmpty)
        setVisibleSingInButton(visible: contentField)
    }
    
    
}

