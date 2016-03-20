//
//  BridgeViewController.swift
//  Bridge
//
//  Created by Blake Engelhard on 2/21/16.
//  Copyright © 2016 Blake Engelhard. All rights reserved.
//

import UIKit
import FBSDKCoreKit



class BridgeViewController: UIViewController {

    @IBOutlet weak var user1DisplayName: UILabel!
    @IBOutlet weak var user1Image: UIImageView!
    var usersBridged = [String]()
    var usersRejected = [String]()
    var usersFriends = [String]()
    var userOptions = [String]()
    
    var userName1 = ""
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        var usersBridgedOrRejected = ""
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if label.center.x < 100 {
                print ("Not chosen")
                usersBridgedOrRejected = "usersRejected"
            } else if label.center.x > self.view.bounds.width - 100 {
                print("chosen")
                usersBridgedOrRejected = "usersBridged"
            }
            
            if usersBridgedOrRejected != "" {
              
                
            }
            
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        
            updateImage()
        
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got to the view Did Load")
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        user1Image.addGestureRecognizer(gesture)
        user1Image.userInteractionEnabled = true
        
        updateImage()
        
    }
    
    
    //update Image with picture of user not listed in usersBridged or usersRejected
    func updateImage() {
      
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}









//        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
//
//        graphRequest.startWithCompletionHandler( {
//            (connection, result, error) -> Void in
//            if error != nil {
//                print(error)
//            } else if let result = result {
//                let usersRef = ref.childByAppendingPath("users")
//                let user1Ref = usersRef.childByAppendingPath(ref.authData.uid)
//                user1Ref.childByAppendingPath("id").setValue(result["id"] as! String)
//                if var userGender = result["gender"] as? String {
//                    user1Ref.childByAppendingPath("gender").setValue(userGender as! String)
//                }
//                if var userLocation = result["location"] as? String {
//                    user1Ref.childByAppendingPath("location").setValue(userLocation as! String)
//                }
//
//                let userId = result["id"] as! String
//                var facebookProfPicURL = "https:/graph.facebook.com/" + userId + "/picture?Type=large"
//                user1Ref.childByAppendingPath("ProfilePicture").setValue(facebookProfPicURL)
//
//                if let fbpicURL = NSURL(string: facebookProfPicURL) {
//                    if let data = NSData(contentsOfURL: fbpicURL) {
//                        self.user1Image.image = UIImage(data: data)
//                    }
//                }
//
//
//            }
//        })
