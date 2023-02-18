//
//  WebViewController.swift
//  TinkoffExam
//
//  Created by Danil Komarov on 17.02.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadRequest1()
    }
    
    private func loadRequest1(){
        DispatchQueue.main.async {
            guard let url = URL(string: urlWK) else {return}
            let urlRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }
    

}
