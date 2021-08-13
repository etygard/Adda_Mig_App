//
//  FacebookModel.swift
//  WGOBook
//
//  Created by Waleerat Gottlieb on 2020-10-14.
//

import Foundation

struct AuthenticationRef {
    let currentUserId: String
    let token: String
    let refId: String
    let name: String
    let email: String
    let signupWith: String
    
    var dictionary: [String : Any] {
        return [kTOKEN : token, kFBID : refId, kFBNAME : name, kFBEMAIL : email, kSIGNUPWITH: signupWith]
    }
    
    func saveToFireStore() {
        FirebaseReference(.AuthenticationRef).document(self.currentUserId).setData(self.dictionary)
    }
}
