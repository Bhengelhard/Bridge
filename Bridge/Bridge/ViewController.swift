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

var ref = Firebase(url: "https://sweltering-fire-7889.firebaseio.com/")


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var FBLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        FBLoginButton.center = self.view.center
        FBLoginButton.delegate = self
        self.view.addSubview(FBLoginButton)
        
        //how to add fields and the corresponding info
        /*var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
        var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
        
        var usersRef = ref.childByAppendingPath("users")
        
        var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
        usersRef.setValue(users)*/

        //how to reference and remove fields
        /*let usersRef = ref.childByAppendingPath("/users")
        usersRef.removeValue()*/

        /*ref.observeEventType(.Value, withBlock:  {
            snapshot in
            self.testLabel.text = snapshot.value as? String
        })*/
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let accessToken = FBSDKAccessToken.currentAccessToken().tokenString {
            ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                if error != nil {
                    print("Login failed. \(error)")
                    //an error occure while attempting login
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch(errorCode) {
                        case .UserDoesNotExist:
                            print("Handle Invalid User")
                        case .InvalidEmail:
                            print("Handle invalid email")
                        case .InvalidPassword:
                            print("Handle invalid passowrd")
                        default:
                            print("Handle default situation")
                        }
                    }
                } else {
                    print("Logged in! \(authData.uid)")
                    self.performSegueWithIdentifier("showApp", sender: self)
                }
            })
        }
        /*
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in")
        } else {
            print("logged in")
            //performSegueWithIdentifier("showApp", sender: self)
        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateWheather(sender: AnyObject) {
        ref.setValue(sender.titleLabel?!.text)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let accessToken = FBSDKAccessToken.currentAccessToken().tokenString {
            ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                if error != nil {
                    print("Login failed. \(error)")
                    //an error occure while attempting login
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch(errorCode) {
                        case .UserDoesNotExist:
                            print("Handle Invalid User")
                        case .InvalidEmail:
                            print("Handle invalid email")
                        case .InvalidPassword:
                            print("Handle invalid passowrd")
                        default:
                            print("Handle default situation")
                        }
                    }
                } else {
                    print("Logged in! \(authData)")
                    let newUser = ["provider": authData.provider, "displayName": authData.providerData["displayName"] as? NSString as? String]
                    ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
                    
                    graphRequest.startWithCompletionHandler( {
                        (connection, result, error) -> Void in
                        if error != nil {
                            print(error)
                        } else if let result = result {
                            let userRef = ref.childByAppendingPath("users").childByAppendingPath(ref.authData.uid)
                            userRef.childByAppendingPath("id").setValue(result["id"] as! String)
                            if let userGender = result["gender"] as? String {
                                userRef.childByAppendingPath("gender").setValue(userGender as! String)
                            }
                            if let userLocation = result["location"] as? String {
                                userRef.childByAppendingPath("location").setValue(userLocation as! String)
                            }
                            userRef.childByAppendingPath("ProfilePictureURL").setValue("https:/graph.facebook.com/" + (result["id"] as! String) + "/picture?Type=large")
                        }
                    })

                    self.performSegueWithIdentifier("showApp", sender: self)
                }
            })
        } else {
            print("Canceled")
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
        ref.unauth()
    }

    
    
    

}

