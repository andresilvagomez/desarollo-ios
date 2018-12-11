//
//  SignInViewModel.swift
//  PlatziFinanzas
//
//  Created by Andres Silva on 12/10/18.
//  Copyright © 2018 Platzi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit
import TwitterKit
import AccountKit

typealias SignInHandler = ( (_ success: Bool, _ error: Error?) -> Void )

class SignInViewModel: NSObject {
    private var handler: SignInHandler?

    static func signInWith(email: String?, password: String?, handler: SignInHandler?) {
        guard let email = email,
            validate(text: email, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") else {
                return
        }
        
        guard let password = password,
            validate(text: password, regex: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$") else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                handler?(false, error)
            }
            
            if result != nil {
                handler?(true, nil)
            }
        }
        
    }
    
    static private func validate(text: String, regex: String) -> Bool {
        let range = NSRange(location: 0, length: text.count)
        let regex = try? NSRegularExpression(pattern: regex)
        return regex?.firstMatch(in: text, options: [], range: range) != nil
    }
    
    static func authWithFacebook(viewController: UIViewController, handler: SignInHandler?) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: viewController) { (result, error) in
            if let error = error {
                handler?(false, error)
                return
            }
            
            guard let token = FBSDKAccessToken.current()?.tokenString else {
                handler?(false, nil)
                return
            }
            let credentials = FacebookAuthProvider.credential(withAccessToken: token)
            
            Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, authError) in
                if let authError = authError {
                    handler?(false, error)
                    return
                }
                
                handler?(true, nil)
            })
        }
    }
    
    static func authWithTwitter(handler: SignInHandler?) {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            guard let session = session else {
                handler?(false, nil)
                return
            }
            
            let authToken = session.authToken
            let authSecret = session.authTokenSecret
            
            let creadentials = TwitterAuthProvider.credential(withToken: authToken, secret: authSecret)
            
            Auth.auth().signInAndRetrieveData(with: creadentials, completion: { (result, error) in
                if let error = error {
                    handler?(false, error)
                    return
                }
                
                handler?(true, nil)
            })
        }
    }
    
    func authAccountKit(sender: UIViewController, handler: SignInHandler?) {
        self.handler = handler
        let viewController = AKFAccountKit(responseType: .accessToken).viewControllerForPhoneLogin() as AKFViewController
        viewController.delegate = self
        
        guard let normalViewController = viewController as? UIViewController else {
            return
        }
        
        sender.present(normalViewController, animated: true, completion: nil)
    }
}

extension SignInViewModel: AKFViewControllerDelegate {
    func viewController(
        _ viewController: (UIViewController & AKFViewController)!,
        didCompleteLoginWith accessToken: AKFAccessToken!,
        state: String!) {
        let token = accessToken.tokenString
        
        let baseUrl = URL(string: "https://us-central1-platzi-finanzas-31d69.cloudfunctions.net/")
        guard let url = URL(string: "accountkit?access_token=\(token)", relativeTo: baseUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                self?.handler?(false, error)
                return
            }
            
            guard let data = data else { return }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
            guard let token = json?["token"] as? String else { return }
            
            Auth.auth().signIn(withCustomToken: token, completion: { [weak self] (result, error) in
                if let error = error {
                    self?.handler?(false, error)
                    return
                }
                
                self?.handler?(true, nil)
            })
        }
        
        task.resume()
    }
}
