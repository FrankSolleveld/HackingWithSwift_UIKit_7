//
//  DetailViewController.swift
//  Project7
//
//  Created by Frank Solleveld on 24/02/2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    // MARK: Customer Variables
    var webView: WKWebView!
    var detailItem: Petition?
    
  
    // MARK: Lifecycle Methods & Overrides
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailItem = detailItem else { return }
        let html = """
        <html>
        <head>
        <meta name = "viewport" content="width=device-width", initial-scale=1">
        <style>
            body {
                font-size: 150%;
            }
        </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        <html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // MARK: Custom Methods
    
    
    // MARK: Delegate Methods
    

}
