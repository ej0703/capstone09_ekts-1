//
//  ViewController.swift
//  ekts
//
//  Created by mac on 2019. 5. 2..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myURL = URL(string: "https://ekts.com/main.do?mobYn=Y&conType=Y")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    
}
