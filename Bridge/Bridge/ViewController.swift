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

    @IBOutlet weak var testLabel: UILabel!
    var ref = Firebase(url: "https://sweltering-fire-7889.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in")
        } else {
            print("logged in")
        }
        
        var FBLoginButton = FBSDKLoginButton()
        FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        FBLoginButton.center = self.view.center
        
        FBLoginButton.delegate = self
        
        self.view.addSubview(FBLoginButton)
        
        
        ref.observeEventType(.Value, withBlock:  {
            snapshot in
            self.testLabel.text = snapshot.value as? String
        })
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateWheather(sender: AnyObject) {
        ref.setValue(sender.titleLabel?!.text)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Login complete.")
            //add saving the information to the database
            self.performSegueWithIdentifier("showNew", sender: self)
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }


}

