//
//  userTextLibrary.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-27.
//

import Foundation

struct profile {
    static let suggessUpdateProfile = "Click pencil icon to update profile"
    static let profileHeader = "Your Profile"
    static let aboutMe = "BIO"
    static let birthday = "Birthday"
    static let gendar = "Gendar"
    static let male = "Male"
    static let female = "Female"
    static let status = "Status"
    static let single = "Single"
    static let married = "Married"
    static let city = "City"
    static let country = "Country"

    static let lookingForHeader = "Looking For?"
    static let lookingForHelp = "Looking for Help"
    static let lookingForJob = "Looking For Job"

    static let kindOfHelpHeader = "Kind Of Help?"
    static let kindOfHelpOne = "Cleaning"
    static let KineOfHelpTwo = "Shopping"
    static let KindOfHelpThree = "Baby Sister"
    static let KindOfHelpFour = "Cooking"
    static let GeneralQuestionHeader = "Other Question"
    static let currentJob = "Current Job"
    static let education = "Education"
} 


struct profileForm {
    static let education = "Education"
    static let kindOfHelp: [String:String] = ["kindOfHelpOne": profile.kindOfHelpOne,
                             "kindOfHelpTwo": profile.KineOfHelpTwo,
                             "kindOfHelpThree": profile.KindOfHelpThree,
                             "kindOfHelpFour": profile.KindOfHelpFour]
}

 

