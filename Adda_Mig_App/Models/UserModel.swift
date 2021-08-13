//
//  userModel.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-16.
//

import Foundation
import Firebase
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class userModel: Equatable {
    static func == (lhs: userModel, rhs: userModel) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String
    var email: String
    var username: String
    var dateOfBirth: Date
    var gendar: String
    var avatar: UIImage?
    var avatarLink: String
    var coverImage: UIImage?
    var coverImageLink: String
    
    var about: String
    var city: String
    var country: String
    var lookingFor: [String]?
    var likedIdArray: [String]?
    var imageLinks: [String]?
    
    var kindOfHelp: [String]?
    var married: String
    var jobTitle: String
    var education: String
    
    var signupWith : String
    let registeredDate = Date()
    var pushId: String?
    
    var userDictionary: NSDictionary {
        
        return NSDictionary(objects: [
                                    self.objectId,
                                    self.email,
                                    self.username,
                                    self.dateOfBirth,
                                    self.gendar,
                                    self.avatarLink,
                                    self.coverImageLink,
                                    self.about,
                                    self.city,
                                    self.country,
                                    self.lookingFor ?? [],
                                    self.kindOfHelp ?? [],
                                    self.married,
                                    self.jobTitle,
                                    self.education,
                                    self.likedIdArray ?? [],
                                    self.imageLinks ?? [],
                                    self.signupWith,
                                    self.registeredDate
            ],
      
            
            forKeys: [kOBJECTID as NSCopying,
                      kEMAIL as NSCopying,
                      kUSERNAME as NSCopying,
                      kDATEOFBIRTH as NSCopying,
                      kGENDAR as NSCopying,
                      kAVATARLINK as NSCopying,
                      KCOVERIMAGELINK as NSCopying,
                      kABOUT as NSCopying,
                      kCITY as NSCopying,
                      kCOUNTRY as NSCopying,
                      kLOOKINGFOR as NSCopying,
                      kKINDOFHELP as NSCopying,
                      kMARRIED as NSCopying,
                      kJOBTITLE as NSCopying,
                      kEDUCATION as NSCopying,
                      kLIKEDIDARRAY as NSCopying,
                      kIMAGELINKS as NSCopying,
                      kSIGNUPWITH as NSCopying,
                      kREGISTERDATE as NSCopying
                ])
        
    }
    
    //MARK: - Inits
    init(_objectId: String, _email: String, _username: String, _gendar: String, _dateOfBirth: Date, _avatarLink: String = "", _signupWith: String) {
        objectId = _objectId
        email = _email
        username = _username
        dateOfBirth = _dateOfBirth
        gendar = _gendar
        avatarLink = _avatarLink
        coverImageLink = ""
        about = ""
        city = ""
        country = ""
        lookingFor = []
        kindOfHelp = []
        married = ""
        jobTitle = ""
        education = ""
        likedIdArray = []
        imageLinks = []
        signupWith = _signupWith
    }
    
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as? String ?? ""
        email = _dictionary[kEMAIL] as? String ?? ""
        username = _dictionary[kUSERNAME] as? String ?? ""
        gendar = _dictionary[kGENDAR] as? String ?? "Unknown"
        avatarLink = _dictionary[kAVATARLINK] as? String ?? ""
        coverImageLink = _dictionary[KCOVERIMAGELINK] as? String ?? ""
        about = _dictionary[kABOUT] as? String ?? ""
        city = _dictionary[kCITY] as? String ?? ""
        country = _dictionary[kCOUNTRY] as? String ?? ""
        lookingFor = _dictionary[kLOOKINGFOR] as? [String]
        kindOfHelp = _dictionary[kKINDOFHELP] as? [String]
        married = _dictionary[kMARRIED] as? String ?? ""
        jobTitle = _dictionary[kJOBTITLE] as? String ?? ""
        education = _dictionary[kEDUCATION] as? String ?? ""
        likedIdArray = _dictionary[kLIKEDIDARRAY] as? [String]
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        signupWith = _dictionary[kSIGNUPWITH] as? String ?? ""
        pushId = _dictionary[kPUSHID] as? String ?? ""
        
        if let date = _dictionary[kDATEOFBIRTH] as? Timestamp {
            dateOfBirth = date.dateValue()
        } else {
            dateOfBirth = _dictionary[kDATEOFBIRTH] as? Date ?? Date()
        }
        
       let placeHolder = getPlaceholder(gendar: gendar) 
       avatar = UIImage(contentsOfFile: fileInDocumentsDirectory(filename: self.objectId)) ?? UIImage(named: placeHolder)
       coverImage = UIImage(contentsOfFile: fileInDocumentsDirectory(filename: self.objectId)) ?? UIImage(named: placeHolder)
    }
    
    //MARK: - Returning current user
    class func currentId() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    class func currentUser() -> userModel? {
        if Auth.auth().currentUser != nil {
            // get userDictionary from userDefaults
            if let userDictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return userModel(_dictionary: userDictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    func getUserAvatarFromFirestore(completion: @escaping (_ didSet: Bool) -> Void) {
        
        FileStorage.downloadImage(imageUrl: self.avatarLink) { (avatarImage) in
            let placeholder = self.getPlaceholder(gendar: self.gendar)
            self.avatar = avatarImage ?? UIImage(named: placeholder)
            completion(true)
        }
        
    }
    
    //MARK: - Register
    class func registerUserWith(email: String, username: String, password: String, dateOfBirth: Date, gendar: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if error == nil {
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verification sent ", error?.localizedDescription ?? "")
                }
                
                if authData?.user != nil {
                    // set value to ModelUser (Class init)
                    let userData = userModel.init(_objectId: authData!.user.uid , _email: email, _username: username, _gendar: gendar, _dateOfBirth: dateOfBirth, _signupWith: "Email")
                    // save to local data
                    userData.saveUserLocally()
                }
                
            }
            completion(error)
        }
    }
    
    // MARK: - Signup with social app
    class func saveAuthenticationRef(_signupToken: String, _signupRefId: String!, _SignupName: String!, _signupEmail: String!, _signupWith: String!){
        if Auth.auth().currentUser != nil {
            let authRef = AuthenticationRef(currentUserId: currentId(), token: _signupToken, refId: _signupRefId, name: _SignupName, email: _signupEmail, signupWith: _signupWith)
            authRef.saveToFireStore()
            
            let userData = userModel.init(_objectId: currentId() , _email: _signupEmail!, _username: _SignupName!, _gendar: "N", _dateOfBirth: Date(), _signupWith: _signupWith)
            userData.saveUserLocally()
            
            FirebaseListener.shared.downloadCurrentUserFromFirebase(userId: currentId() , email: _signupEmail!)
        }
    }
    
    class func signinViaApple(user: User ,completion: @escaping (_ error: Error?) -> Void) {
        print("Nice to meet you \(user.uid) your email : \(user.email ?? "")")
        
        
    }
    
    class func signinViaFacebook(credential: AuthCredential, tokenString: String,completion: @escaping (_ error: Error?) -> Void) {
        
            Auth.auth().signIn(with: credential) { (authData, error) in
                if error != nil {
                    completion(error)
                    return
                }
                
                FBSDKCoreKit.GraphRequest(graphPath: "/me", parameters: ["fields" : "id,name,email"]).start { (connection, FbResult, error) in
                    if error != nil {
                        completion(error)
                        return
                    }
                    if let authRef = FbResult as? NSDictionary {
                        saveAuthenticationRef(_signupToken: tokenString,
                                                     _signupRefId: authRef["id"] as? String,
                                                     _SignupName: authRef["name"] as? String,
                                                     _signupEmail: authRef["email"] as? String ?? "",
                                                     _signupWith: "Facebook"
                        )
                    }
                }
            }
         
    }
    
    class func signinWithGmail(credential: AuthCredential, user: GIDGoogleUser!, completion: @escaping (_ error: Error?) -> Void) {
       
            Auth.auth().signIn(with: credential) { (authData, error) in
                if error != nil {
                    completion(error)
                }else {
                    userModel.saveAuthenticationRef(_signupToken: user.authentication.idToken!,
                                                 _signupRefId: user.userID!,
                                                 _SignupName: user.profile.name!,
                                                 _signupEmail: user.profile.email!,
                                                 _signupWith: "Gmail")
                }
            }
        
    }
    
    //MARK: - Login
    class func loginUserwith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        // Check Authentication
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                // If email is verified
                if authDataResult!.user.isEmailVerified {
                    // get Current User from Firebase , check process in FirebaseListener.swift
                    FirebaseListener.shared.downloadCurrentUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    //MARK: - Edit User profile
    
    func updateUserEmail(newEmail: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            
            userModel.resendVerificationEmail(email: newEmail) { (error) in

            }
            completion(error)
        })
    }

    
    
    //MARK: - Resend Links
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                completion(error)
            })
        })
    }
    
    
    
    //MARK: - LogOut user
    
    class func logOutCurrentUser(completion: @escaping(_ error: Error?) ->Void) {
        
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            GIDSignIn.sharedInstance()?.signOut()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
        
        let loginManager = LoginManager()
        loginManager.logOut() // this is an instance function
        
    }

    
    //MARK: - Save user funcs
    func saveUserLocally() {
        userDefaults.setValue(self.userDictionary as! [String : Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
    }
    
    func saveUserToFireStore() {
                
        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    // MARK: - Update User Funcs
    func updateCurrentUserInFireStore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
        if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
            
            let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
            userObject.setValuesForKeys(withValues)
            
            FirebaseReference(.User).document(userModel.currentId()).updateData(withValues) {
                error in
              
                completion(error)
                if error == nil {
                    userModel(_dictionary: userObject).saveUserLocally()
                }
            }
        }
    }
    
    
    
    
    // MARK: - Reset password
    class func resetPassword(email: String, completion: @escaping (_ response: String) -> Void) {
        
        FirebaseReference(.User)
            .whereField("email", isEqualTo: email)
           // .whereField("signupWith", isEqualTo: "Email")
            .getDocuments() { (querySnapshot, error) in
                if error != nil {
                    completion("101")
                    return
                } else {
                    if (querySnapshot != nil) {
                        for document in querySnapshot!.documents {
                            let sighupWith : String = document.data()["signupWith"] as! String
                            if (sighupWith == "Email") {
                                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                                    if (error != nil){
                                        completion("102")
                                        return
                                    }else {
                                        completion("100")
                                        return
                                    }
                                }
                            } else {
                                completion("\(document.data()["signupWith"] ?? "Facebook or Gmail")")
                                return
                            }
                        }
                        
                    } else {
                        completion("103")
                        return
                    }
                }
                completion("104")
            }
        
    }
    
    func getPlaceholder(gendar: String) -> String{
        var placeholder = "avatar"
        if gendar == "Male" {
            placeholder = "mPlaceholder"
        } else if gendar == "Female" {
            placeholder = "fPlaceholder"
        }
        return placeholder
    }
    
    // MARK: - Dummy Users
    class func createUsers() {
        
        let names = ["Alison Stamp", "Inayah Duggan", "Alfie-Lee Thornton", "Rachelle Neale", "Anya Gates", "Juanita Bate"]
        
        var imageIndex = 1
        var userIndex = 1
        var isMale = true
        
        for i in 0..<5 {
            
            let id = UUID().uuidString
            
            let fileDirectory = "Avatars/_" + id + ".jpg"

            FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
                let user = userModel(_objectId: id, _email: "user\(userIndex)@mail.com", _username: names[i], _gendar: "Male", _dateOfBirth: Date(), _avatarLink: avatarLink ?? "", _signupWith: "DummyData")
                
                isMale.toggle()
                userIndex += 1
                user.saveUserToFireStore()
            }
            
            imageIndex += 1
            
            if imageIndex == 16 {
                imageIndex = 1
            }
            
        }

    } 
    
    
}





