//
//  LoginFormViewController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 12.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import WebKit

class LoginFormViewController: UIViewController {

  @IBOutlet weak var webView: WKWebView! {
    didSet {
      webView.navigationDelegate = self
    }
  }
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
     requestLoginUrl()
  }
  
  private func requestLoginUrl() {
    // Create a login URL with all required parameters
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "oauth.vk.com"
    urlComponents.path = "/authorize"
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: APIService.instance.appid),
      URLQueryItem(name: "display", value: "mobile"),
      URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
      URLQueryItem(name: "scope", value: "274438"),
      URLQueryItem(name: "response_type", value: "token"),
      URLQueryItem(name: "v", value: APIService.instance.apiVersion)
    ]
    let request = URLRequest(url: urlComponents.url!)
    webView.load(request)
  }
}

extension LoginFormViewController: WKNavigationDelegate {
  // Analyze navigation response to get access token
  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
      decisionHandler(.allow)
      return
    }
    
    let parameters = fragment
      .components(separatedBy: "&")
      .map { $0.components(separatedBy: "=")}
      .reduce([String: String]()) { result, parameters in
        var dictionary = result
        let key = parameters[0]
        let value = parameters[1]
        dictionary[key] = value
        return dictionary
    }
    
    APIService.instance.authToken = parameters["access_token"]!
    decisionHandler(.cancel)
    
    // Update all the info before login has finished
    refreshUsersData()
    
    performSegue(withIdentifier: "userHasLoggedIn", sender: nil)
  }
  
  private func refreshUsersData() {
    APIService.instance.requestUsersFriendsList()
    APIService.instance.requestUsersGroups()
    NewsFeedService.instance.requestUsersNewsFeed()
    ConversationsService.instance.requestUsersConversations()
  }
  
  // Provide web browser navigation state to user
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    activityIndicator.startAnimating()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicator.stopAnimating()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    activityIndicator.stopAnimating()
  }
}
