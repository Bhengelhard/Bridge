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
        
        let usersRef = ref.childByAppendingPath("users")
        
        var usersBridgedOrRejected = ""
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if label.center.x < 100 {
                print ("Not chosen")
                usersBridgedOrRejected = "rejected"
            } else if label.center.x > self.view.bounds.width - 100 {
                print("chosen")
                usersBridgedOrRejected = "bridged"
            }
            
            /*let postRef = ref.childByAppendingPath("posts")
            let post1 = ["author": "gracehop", "title": "Announcing COBOL, a New Programming Language"]
            let post1Ref = postRef.childByAutoId()
            post1Ref.setValue(post1)*/
            
            let user1Ref = usersRef.childByAppendingPath("user8").childByAppendingPath("usersBridged")
                
            let user1usersBridged = user1Ref.childByAutoId()
            
            user1usersBridged.setValue(userName1)
            
            
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
        //print(ref.authData.uid)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        user1Image.addGestureRecognizer(gesture)
        user1Image.userInteractionEnabled = true
        
        updateImage()
        
        
        
        //var ref2 = Firebase(url:"https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts")
        // Retrieve two users profile pictures and names as they are added to your database
        
    }
    
    func updateImage() {
        
        let usersRef = ref.childByAppendingPath("users")
        usersRef.queryLimitedToLast(1)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let profilePictureURL = snapshot.value.objectForKey("ProfilePictureURL") as? String {
                    //show picture
                    if let fbpicURL = NSURL(string: profilePictureURL) {
                        if let data = NSData(contentsOfURL: fbpicURL) {
                            self.user1Image.image = UIImage(data: data)
                        }
                    }
                }
                if let displayName = snapshot.value.objectForKey("displayName") as? String {
                    self.user1DisplayName.text = snapshot.value.objectForKey("displayName")! as! String
                }
                if let userName = snapshot.key as? String {
                    self.userName1 = snapshot.key! as! String
                }
                
            })

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












/*usersRef.queryLimitedToLast(1)
 .observeEventType(.ChildAdded, withBlock: { snapshot in
 //returns the potential user -> need to make it random or later based on a location and Bridge Status algorithm
 print(snapshot.value.objectForKey("ProfilePictureURL"))
 //print("this is the key")
 /*if let fbpicURL = NSURL(string: facebookProfPicURL) {
 if let data = NSData(contentsOfURL: fbpicURL) {
 self.user1Image.image = UIImage(data: data)
 }
 }*/
 
 })*/
// Get a reference to our posts
/*var ref2 = Firebase(url:"https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts")
 // Retrieve new posts as they are added to your database
 ref2.observeEventType(.ChildAdded, withBlock: { snapshot in
 print(snapshot.value.objectForKey("author"))
 print(snapshot.value.objectForKey("title"))
 })*/

/*usersRef.observeEventType(.Value) { (snapshot) in
 usersRef.queryLimitedToLast(1).observeSingleEventOfType(.Value, withBlock: { (querySnapshot) in
 print(snapshot.value)
 })
 }*/
/*ref.childByAppendingPath("stegosaurus").childByAppendingPath("height")
 .observeEventType(.Value, withBlock: { stegosaurusHeightSnapshot in
 if let favoriteDinoHeight = stegosaurusHeightSnapshot.value as? Double {
 let queryRef = ref.queryOrderedByChild("height").queryEndingAtValue(favoriteDinoHeight).queryLimitedToLast(2)
 queryRef.observeSingleEventOfType(.Value, withBlock: { querySnapshot in
 if querySnapshot.childrenCount == 2 {
 let child: FDataSnapshot = querySnapshot.children.nextObject() as FDataSnapshot
 println("The dinosaur just shorter than the stegasaurus is \(child.key)");
 } else {
 println("The stegosaurus is the shortest dino");
 }
 })
 }
 })*/

//print(ref.childByAppendingPath("users").valueForKey("user1") as! String)
/*ref.observeEventType(.Value, withBlock:  {
 snapshot in
 print(snapshot.value)
 })

 ref.queryOrderedByChild("users/user1/ProfilePictureURL").observeEventType(.ChildAdded, withBlock: {
 snapshot in
 print("got into query")
 //let profilePictureURL2 = snapshot.value["ProfilePictureURL"] as? String
 //print(profilePictureURL2)
 if let profilePictureURL = snapshot.value["ProfilePictureURL"] as? String {
 print("\(snapshot.key) was \(profilePictureURL) meters tall")
 }
 print(snapshot.value)
 })

 ref.childByAppendingPath("users").observeEventType(.Value, withBlock: { snapshot in
 print(snapshot.value)
 }, withCancelBlock: { error in
 print(error.description)
 })
 
 let urlArray = ["https://s-media-cache-ak0.pinimg.com/236x/9b/a2/57/9ba25796112cad616be27e473ae1e149.jpg",
 "https://img.buzzfeed.com/buzzfeed-static/static/2015-08/18/13/enhanced/webdr13/grid-cell-15170-1439918492-2.jpg",
 "http://www.fastcharacters.com/wp/wp-content/uploads/famous-cartoon-character-homer-simpson.jpg",
 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhJW2O2P2tx43KGxhARMf5tg9f8bqKZCPlEZceAa3JGe2t5Q4e",
 "http://static.giantbomb.com/uploads/original/2/28240/1649408-woodywoodpecker1.jpg",
 "http://allcartooncharacters.com/wp-content/uploads/2014/10/spongebob-squarepants.jpg",
 "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTaKYPA-cevTLKO2rcd-pSaw1Qzm1b_KV1SobRmioO96La7qFUW",
 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG413kdOpTHcr4RLQ0OpFjrOBpAwBKD-r9DzYfQDnonmXjiNd_dg",
 "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQL42yFj86DAYMEAOrbpKYXm1fKTseGci6h9-NmIqLYIV3GSP_b"]
 
 var counter = 1
 for url in urlArray {
 let userRef = ref.childByAppendingPath("users").childByAppendingPath("user\(counter)")
 userRef.childByAppendingPath("gender").setValue("female" as! String)
 userRef.childByAppendingPath("ProfilePictureURL").setValue(url as! String)
 userRef.childByAppendingPath("displayName").setValue("user\(counter)" as! String)
 
 counter += 1
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

//how to add fields and the corresponding info
var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
 var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
 
 var usersRef = ref.childByAppendingPath("users")
 
 var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
 usersRef.setValue(users)*/