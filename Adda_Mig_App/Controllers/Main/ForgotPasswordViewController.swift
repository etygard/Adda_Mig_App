//
//  ForgotPasswordViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-18.
//

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Vars
    var email: String!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.text = email!
    }
    
    @IBAction func resetPasswordBntPress(_ sender: UIButton) {
        if emailTextfield.text != "" {
            //reset password
            userModel.resetPassword(email: emailTextfield.text!) { (response) in
                // 101 query error / 102 reset password error / 100 reset password / 103 not found email/ "signup with"
                switch response {
                    case "100" : ProgressHUD.showSuccess("Please check your email")
                    case "101","102","103","104" : ProgressHUD.showSuccess("Not found you email in the system")
                    default : ProgressHUD.showSuccess("You have signed in with \"\(response)\" account")
                }
            }
        }else {
            //show error
            ProgressHUD.showError("Please insert your email address.")
        }
        
    }
    
    @IBAction func gotoSiginScreenPress(_ sender: UIButton) {
        let mainView = UIStoryboard.init(name: NavgationHelper.LoginScreen.StoryboardName, bundle: nil).instantiateViewController(identifier: NavgationHelper.LoginScreen.ControllerIdentifier)
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    

}
