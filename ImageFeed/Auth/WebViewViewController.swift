//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Сергей Петров on 27.02.2026.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthView()
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
            ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

}
