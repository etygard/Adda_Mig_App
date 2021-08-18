//
//  AppDelegate.swift
//  Adda_Mig_App
//
//  Created by Emma tygard on 2021-08-12.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import FirebaseUI



@main
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // For Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        // For Google
        // Initialize sign-in for Google
        GIDSignIn.sharedInstance().clientID = "991508234445-0gsclljv4gp8qiqqhac9fk9im7v35cnc.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        // For firebase
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        // For Google
        return GIDSignIn.sharedInstance().handle(url)
    }

    
    // MARK: - Google Signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
            if let error = error {
                print("Signin via Gmail error :", error.localizedDescription)
                return
            }

            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
       
            userModel.signinWithGmail(credential: credential, user: user!) { (error) in
                print("Authentication Gmail error :", error?.localizedDescription ?? "None")
                return
            }
       
            DispatchQueue.main.async { self.goToApp() }
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // Function for redirect to Main Screen
    private func goToApp(){
        let story = UIStoryboard(name: NavgationHelper.AfterLoginScreen.StoryboardName, bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: NavgationHelper.AfterLoginScreen.ControllerIdentifier) as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
}
