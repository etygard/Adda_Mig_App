//
//  ViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-16.
//

import UIKit
import ProgressHUD
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

import GoogleSignIn
import FirebaseUI

class MainNavigationController: UINavigationController {

override var shouldAutorotate: Bool {
   return false    }

}


class SigninViewController: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var GmailLoginButton: GIDSignInButton!
    @IBOutlet weak var facdbookLoginBnt: FBLoginButton!
    
    
    // MARK: - Vars
    var fbToken:String = ""
    var currentUserId:String = ""
    // define authListener
    var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark // set the dark mode
        setupBackGroundTouch()
        // Remark : Auto login setting is in  SceneDelegate.swift
        //For Google
        GIDSignIn.sharedInstance()?.presentingViewController = self
 
    }
    
    // 4. Login Process
    @IBAction func loginBntPress(_ sender: UIButton) {
        if emailTextfield.text != ""  && passwordTextfield.text != "" {
            
            ProgressHUD.show()
            userModel.loginUserwith(email: emailTextfield.text! , password: passwordTextfield.text!) { (error, isEmailVerified) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                }else if isEmailVerified {
                    // Success! go to the next process
                    self.gotoApp()
                } else {
                    ProgressHUD.showError("Please verify your Email")
                }
            }
        }else {
            //show error
            ProgressHUD.showError("Please insert your email address.")
        }
    }
     

    // MARK: - Setup
    // 1. - Dismiss keyboard
    func setupBackGroundTouch(){
        bgImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        // add to imageView
        bgImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap(){
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    // MARK: - Navigation
    private func gotoApp(){
        let mainView = UIStoryboard.init(name: NavgationHelper.AfterLoginScreen.StoryboardName, bundle: nil).instantiateViewController(identifier: NavgationHelper.AfterLoginScreen.ControllerIdentifier) as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
        
    }
    
    private func gotoLogin(){
        let mainView = UIStoryboard.init(name: NavgationHelper.LoginScreen.StoryboardName, bundle: nil).instantiateViewController(identifier: NavgationHelper.LoginScreen.ControllerIdentifier)
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoForgotpasswordScreen" {
            let destinationVC = segue.destination as! ForgotPasswordViewController
            destinationVC.email =  emailTextfield.text!
        }
    }
 
}


// MARK: - Signup via Apple
extension SigninViewController : FUIAuthDelegate {
    
    @IBAction func appleLoginButton(_ sender: Any) {
        if let authUI = FUIAuth.defaultAuthUI(){
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            userModel.signinViaApple(user: user) { (error) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                }else {
                    ProgressHUD.showSuccess("Registered")
                }
            }
            //userModel.signinViaApple(user: user, completion: (Error?) -> Void)
            
        }
    }
 
}


// MARK: - Signup via Facebook
extension SigninViewController: LoginButtonDelegate {
    
    @IBAction func facebookLoginBntPress(_ sender: FBLoginButton) {
        facdbookLoginBnt.isHidden = true
        facdbookLoginBnt.delegate = self
    }

     
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let token = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            let tokenString = token.tokenString
            userModel.signinViaFacebook(credential: credential, tokenString: tokenString) { (error) in
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                    return
                }
            }
            if (token.tokenString != "") { self.gotoApp()}
        } 
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        userModel.logOutCurrentUser { (error) in
            if error == nil {
                self.gotoLogin()
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
}
