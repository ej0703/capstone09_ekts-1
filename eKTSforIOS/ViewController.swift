//
//  ViewController.swift
//  eKTSforIOS
//
//  Created by jisooooo on 08/04/2019.
//  Copyright © 2019 jisooooo. All rights reserved.
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

