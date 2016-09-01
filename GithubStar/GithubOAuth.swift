//
//  GithubOAuth.swift
//  GithubStar
//
//  Created by Yuankun Zhang on 9/1/16.
//  Copyright © 2016 Yuankun Zhang. All rights reserved.
//

import Cocoa
import OAuth2


class GithubOAuth {
    
    let baseURL = NSURL(string: "https://api.github.com")!
    
    lazy var oauth2: OAuth2CodeGrant = OAuth2CodeGrant(settings: [
        "client_id": "8ae913c685556e73a16f",                         // yes, this client-id and secret will work!
        "client_secret": "60d81efcc5293fd1d096854f4eee0764edb2da5d",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["ppoauthapp://oauth/callback"],            // app has registered this scheme
        "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
        "verbose": true,
    ])
    
    func request(path: String, callback: ((dict: OAuth2JSON?, error: ErrorType?) -> Void)) {
        let url = baseURL.URLByAppendingPathComponent(path)
        let req = oauth2.request(forURL: url)
        req.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let task = oauth2.session.dataTaskWithRequest(req) { data, response, error in
            if nil != error {
                dispatch_async(dispatch_get_main_queue()) {
                    callback(dict: nil, error: error)
                }
            }
            else {
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? OAuth2JSON
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(dict: dict, error: nil)
                    }
                }
                catch let error {
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(dict: nil, error: error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func requestUserdata(callback: ((dict: OAuth2JSON?, error: ErrorType?) -> Void)) {
        request("user", callback: callback)
    }
    
    func isAuthorized() -> Bool {
        return oauth2.hasUnexpiredAccessToken()
    }
    
    func authorize(window: NSWindow?, callback: (wasFailure: Bool, error: ErrorType?) -> Void) {
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = window
        oauth2.afterAuthorizeOrFailure = callback
        oauth2.authorize()
    }
    
    func handleRedirectURL(url: NSURL) {
        oauth2.handleRedirectURL(url)
    }
}