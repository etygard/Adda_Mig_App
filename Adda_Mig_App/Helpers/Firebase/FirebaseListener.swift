//
//  FirebaseListener.swift
//  WGOBook
//
//  Created by Waleerat Gottlieb on 2020-10-13.
//

import Foundation
import Firebase

class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init(){}

    // MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String){
        FirebaseReference(.User).document(userId).getDocument { (Snapshot, error) in
            guard let snapshot = Snapshot else { return } // if not exist return
            
            if snapshot.exists{
                let user = userModel(_dictionary: snapshot.data()! as NSDictionary)
                user.saveUserLocally()
                user.getUserAvatarFromFirestore { (didSet) in }
                
            } else {
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    userModel(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
            }
        }
    }
    
    func downloadSelectedUserFromFirebase(userId: String , completion: @escaping (_ user: userModel) ->Void) { 
        var user: userModel?
        FirebaseReference(.User).document(userId).getDocument { (Snapshot, error) in
            guard let snapshot = Snapshot else { return } // if not exist return
            if snapshot.exists{
                let userObject = snapshot.data()! as NSDictionary
                user = userModel(_dictionary: userObject)
                completion(user!)
            }
            completion(user!)
        }
    }
    
    func downloadUsersFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [userModel], _ snapshot: DocumentSnapshot?) ->Void) {
        
        var query: Query!
        var users: [userModel] = []
            //.whereField("capital", isNotEqualTo: false)
        if isInitialLoad {
            query = FirebaseReference(.User).order(by: kREGISTERDATE, descending: true).limit(to: limit)
            print("first \(limit) users loading")
            
        } else {
            
            if lastDocumentSnapshot != nil {
                query = FirebaseReference(.User).order(by: kREGISTERDATE, descending: true).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                
                print("next \(limit) user loading")

            } else {
                print("last snapshot is nil")
            }
        }
        
        if query != nil {
            
            query.getDocuments { (snapShot, error) in
                 
                guard let snapshot = snapShot else { return }
                
                if !snapshot.isEmpty {
                  
                    for userData in snapshot.documents {
                        
                        let userObject = userData.data() as NSDictionary
                        
                        // add users to array except current user  **
                        //if !(userModel.currentUser()?.likedIdArray?.contains(userObject[kOBJECTID] as! String) ?? false && userModel.currentId() != userObject[kOBJECTID] as! String ) {
                        
                        if  userModel.currentId() != userObject[kOBJECTID] as! String  {
                            if (userModel.currentId() != userObject[kOBJECTID] as! String) {
                                users.append(userModel(_dictionary: userObject))
                            }
                        }
                    }
                    
                    completion(users, snapshot.documents.last!)
                    
                } else {
                    print("no more users to fetch")
                    completion(users, nil)
                }
            }
        } else {
            completion(users, nil)
        }
    } 
     
    

}
