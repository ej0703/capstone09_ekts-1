//
//  ViewController.swift
//  eKTSforIOS
//
//  Created by jisooooo on 08/04/2019.
//  Copyright © 2019 jisooooo. All rights reserved.
//

import UIKit
import WebKit
import Iamport_swift

class ViewController: UIViewController/*, WKUIDelegate*/ {
/*
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
*/
    // 190430 : 기존 코드(위)는 사용하지 않고, 아임포트 예제 위주(아래)로 사용
    
    lazy var webView: UIWebView = {
        var view = UIWebView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) // 190430 : WebView 위치를 명기하여 설정
        view.backgroundColor = UIColor.clear
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white // 190430 : 스크롤해도 WebView 내용물이 아닌 흰색배경이도록
        self.view.addSubview(webView)
        self.webView.frame = self.view.bounds
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0) // 190430 : WebView의 scrollView content를 20만큼 위로 올려줌으로써 상단에 벌어진 공간을 메워줌
        
        // 결제 환경 설정
        IAMPortPay.sharedInstance.configure(scheme: "iamporttest")  // info.plist에 설정한 scheme
        
        IAMPortPay.sharedInstance
            .setWebView(self.webView)   // 현재 Controller에 있는 WebView 지정
            .setRedirectUrl(nil)        // m_redirect_url 주소
        
        // ISP 취소시 이벤트 (NicePay만 가능)
        IAMPortPay.sharedInstance.setCancelListenerForNicePay { [weak self]  in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "ISP 결제 취소", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        // 결제 웹페이지(Remote) 호출
        if let url = URL(string: "https://ekts.com/main.do?mobYn=Y&conType=Y") {
            let request = URLRequest(url: url)
            self.webView.loadRequest(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 해당 함수는 redirecURL의 결과를 직접 처리하고 할 때 사용하는 함수 (IAMPortPay.sharedInstance.configure m_redirect_url 값을 설정해야함.)
        IAMPortPay.sharedInstance.requestRedirectUrl(for: request, parser: { (data, response, error) -> Any? in
            // Background Thread
            var resultData: [String: Any]?
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                switch statusCode {
                case 200:
                    resultData = [
                        "isSuccess": "OK"
                    ]
                    break
                default:
                    break
                }
            }
            return resultData
        }) { (pasingData) in
            // Main Thread
        }
        
        return IAMPortPay.sharedInstance.requestAction(for: request)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 직접 구현..
    }
}

