//
//  NavigationHelper.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-18.
//

import Foundation
struct NavgationHelper {
    struct LoginScreen {
        static let StoryboardName = "Main"
        static let ControllerIdentifier = "loginView"
    }

    struct AfterLoginScreen {
        static let StoryboardName = "UserProfile"
        static let ControllerIdentifier = "UserProfileView"
    }
     
    struct UserProfileScreen {
        static let StoryboardName = "UserProfile"
        static let ControllerIdentifier = "DetailView1"
    }
}

