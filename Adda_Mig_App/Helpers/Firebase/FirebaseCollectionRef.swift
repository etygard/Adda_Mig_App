//
//  FirebaseCollectionRef.swift
//  WGOBook
//
//  Created by Waleerat Gottlieb on 2020-10-13.
//

import Foundation
import FirebaseFirestore

enum FCollectionRefference: String {
    case User
    case UserInfo
    case AuthenticationRef
    case Like
}

func FirebaseReference(_ collectionReference: FCollectionRefference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
