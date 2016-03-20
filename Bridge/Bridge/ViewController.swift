//
//  ViewController.swift
//  Bridge
//
//  Created by Blake Engelhard on 2/17/16.
//  Copyright © 2016 Blake Engelhard. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit



class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var FBLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        FBLoginButton.center = self.view.center
        FBLoginButton.delegate = self
        self.view.addSubview(FBLoginButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
      
      
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in")
        } else {
            print("logged in")
            performSegueWithIdentifier("showApp", sender: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let accessToken = FBSDKAccessToken.currentAccessToken().tokenString {
          print("login failed")
        } else {
          print("Logged in! ")
          let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
          graphRequest.startWithCompletionHandler( { (connection, result, error) -> Void in
            if error != nil {
              print(error)
            } else if let result = result {
              if let userLocation = result["location"] as? String {
                //save location
              }
            } else {
              print("Canceled")
            }
          })
        }
    }
  
  
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }

    
    
    

}

