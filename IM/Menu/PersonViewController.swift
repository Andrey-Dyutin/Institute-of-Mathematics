//
//  PersonViewController.swift
//  IM
//
//  Created by Андрей Дютин on 16.08.2020.
//  Copyright © 2020 Андрей Дютин. All rights reserved.
//

import UIKit
import FirebaseAuth

class PersonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Log out
        view.addSubview(logOutButton)

    }
    //MARK: - Log out
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 32,
                                   y: view.frame.height - 172,
                                   width: view.frame.width - 64,
                                   height: 50)
        button.backgroundColor = .black
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()

    @objc private func signOut() {
        try! Auth.auth().signOut()
        openLoginViewController()
    }
    

}

extension PersonViewController {
    private func openLoginViewController() {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(viewController, animated: true)
                return
            }
            
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
}

