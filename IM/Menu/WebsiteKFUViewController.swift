//
//  WebsiteKFUViewController.swift
//  IM
//
//  Created by Андрей Дютин on 14.08.2020.
//  Copyright © 2020 Андрей Дютин. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAuth

class WebsiteKFUViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string:"https://kpfu.ru") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        checkLoggedIn()
    }
    
    
}

extension WebsiteKFUViewController {
    private func checkLoggedIn() {
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(viewController, animated: true)
                return
            }
        }
    }

}
