//
//  WebViewController.swift
//  Guarana
//
//  Created by Hermann Dorio on 26/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var coordinator: WebViewCoordinator?
    @IBOutlet weak var webView: WKWebView!{
        didSet {
            webView.uiDelegate = self
        }
    }
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView()
    }
    
    func loadWebView(){
        guard let fullURL = url else { return }
        let urlRequest = URLRequest(url: fullURL)
        webView.load(urlRequest)
    }
    
    func setupWebView(urlString: String) {
        url = URL(string: urlString)
    }

}

extension WebViewController: WKUIDelegate {}
