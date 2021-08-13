//
//  GobalFunction.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-28.
//


import Foundation

struct LikeObject {
    
    let id: String
    let userId: String
    let likedUserId: String
    let date: Date
    
    var dictionary: [String : Any] {
        return [kOBJECTID : id, kUSERID : userId, kLIKEDUSERID : likedUserId, kDATE : date]
    }
    
    func saveToFireStore() {
        FirebaseReference(.Like).document(self.id).setData(self.dictionary)
    }
    
    func removeToFireStore(likedUserId: String) {
        FirebaseReference(.Like)
            .whereField("likedUserId", isEqualTo: likedUserId)
            .whereField("userId", isEqualTo: userModel.currentId())
            .getDocuments() { (querySnapshot, err) in
              
                if err != nil {
                     
                } else {
                    for document in querySnapshot!.documents {
                        let Object = document.data() as NSDictionary
                        let deleteLikedobjectId = Object["objectId"] as! String
                        FirebaseReference(.Like).document(deleteLikedobjectId).delete()
                    }
                }
                
        }
    } 
    
}

class LikesModel {
    var numberOfLikes = 0
    
    func saveLikeToUser(userId: String) {
        
        let like = LikeObject(id: UUID().uuidString, userId: userModel.currentId(), likedUserId: userId, date: Date())
        like.saveToFireStore()
        
        
        if let currentUser = userModel.currentUser() {
            
            if !didLikeUserWith(userId: userId) {
                
                currentUser.likedIdArray!.append(userId)
                
                currentUser.updateCurrentUserInFireStore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
                    if (error != nil) {
                        print("updated current user with error ", error?.localizedDescription ?? "")
                    }
                    
                }
            }
        }
    }

    func saveDisLikeToUser(userId: String) {
        
        let like = LikeObject(id: UUID().uuidString, userId: userModel.currentId(), likedUserId: userId, date: Date())
        like.removeToFireStore(likedUserId: userId)
        
        if let currentUser = userModel.currentUser() {
            
            if let tempLikedIdArray = currentUser.likedIdArray {
                // remove array by value
                currentUser.likedIdArray = tempLikedIdArray.filter {$0 != userId}
                currentUser.updateCurrentUserInFireStore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
                    if (error != nil) {
                        print("updated current user with error ", error?.localizedDescription ?? "")
                    }
        
                }
            }
        }
    }
    
    
    class func saveDisLikeToUser1(userId: String , completion: @escaping (_ error : Error?) -> Void) {
        let like = LikeObject(id: UUID().uuidString, userId: userModel.currentId(), likedUserId: userId, date: Date())
        like.removeToFireStore(likedUserId: userId)
        
        if let currentUser = userModel.currentUser() {
            
            if let tempLikedIdArray = currentUser.likedIdArray {
                // remove array by value
                currentUser.likedIdArray = tempLikedIdArray.filter {$0 != userId}
                currentUser.updateCurrentUserInFireStore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
                    if (error != nil) {
                        completion(error)
                    }
                }
            }
        }
    }
     
     

    func didLikeUserWith(userId: String) -> Bool {
        return userModel.currentUser()?.likedIdArray?.contains(userId) ?? false
    }

    // MARK: - Likes Function
    class func numberOfLiks(userId: String, completion: @escaping (_ numberOfLikes : Int) -> Void) {
        FirebaseReference(.Like).whereField("likedUserId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                var totalCount = 0
                if err != nil {
                     
                } else {
                    totalCount = querySnapshot!.documents.count 
                    completion(totalCount)
                    return
                }
                completion(totalCount)
                return
        }
    }
    
    class func getIsCurrentUserLiked(userId: String, completion: @escaping (_ isLiked : Bool?) -> Void) {
       
        FirebaseReference(.Like)
            .whereField("likedUserId", isEqualTo: userId)
            .whereField("userId", isEqualTo: userModel.currentId())
            .getDocuments() { (querySnapshot, err) in
                
                var totalCount = 0
                if err != nil {
                     
                } else {
                    totalCount = querySnapshot!.documents.count
                    let islike = totalCount > 0 ? true : false
                    completion(islike)
                }
                
        }
    }
    
    class func switchUpdateLikedBetweenUnlike(userId: String, completion: @escaping (_ isLiked : Bool?) -> Void) {
        LikesModel.getIsCurrentUserLiked(userId: userId) { (isLiked) in
            let switchFromKey = isLiked ?? false
            completion(switchFromKey)
        }
    }
    
    
    class  func downloadUserLikes(completion: @escaping (_ likeUserIds : [String]) -> Void) {
        FirebaseReference(.Like)
            .whereField("userId", isEqualTo: userModel.currentId())
            .getDocuments() { (querySnapshot, err) in
                var allLikeIds: [String] = []
                
                guard let snapshot = querySnapshot else {
                    completion(allLikeIds)
                    return
                }
                
                if !snapshot.isEmpty {
                    for likeDictionary in snapshot.documents {
                        allLikeIds.append(likeDictionary[kUSERID] as? String ?? "")
                    }
                } else {
                    completion(allLikeIds)
                }
        }
    }
}


