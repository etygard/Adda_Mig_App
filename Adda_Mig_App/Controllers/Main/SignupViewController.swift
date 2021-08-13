//
//  SignupViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-17.
//

import UIKit
import ProgressHUD
import DatePicker

class SignupViewController: UIViewController {

    // MARK: - IBOutLets
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var dateOfBirthTextfield: UITextField!
   
    
    // MARK: - Vars
    var gendar = "N"
    var selectedDateOfBirth: Date?
    var datePicker = UIDatePicker()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGroundTouch()
        EditingMode()
    }
    
    // MARK: - register Process
    @IBAction func RegisterBntPress(_ sender: UIButton) {
        if isTextDataInput() {
            if passwordTextfield.text! == confirmPasswordTextfield.text! {
                registerUser()
            }else {
                ProgressHUD.showError("Password not match!!")
            }
        }else{
            ProgressHUD.showError("All Fields are required")
        }
    }
    
    private func registerUser() {
      
        userModel.registerUserWith(email: emailTextfield.text!, username: usernameTextfield.text!, password: passwordTextfield.text!,dateOfBirth: selectedDateOfBirth ?? Date(), gendar: gendar) { (error) in
             print("Success!!!")
            ProgressHUD.dismiss()
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            } else {
                ProgressHUD.showSuccess("Success! Please check your email and verifiy")
                self.goToLoginPage()
            }
        }
    }
    
    // MARK: - Dismiss Keyboard
    func setupBackGroundTouch(){
        bgImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        // add to imageView
        bgImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap(){
        dismissKeyboard()
    }
    
    // MARK: - Validate textfields
    private func isTextDataInput() -> Bool {
        return (usernameTextfield.text != "" && emailTextfield.text != "" &&  dateOfBirthTextfield.text != "" && passwordTextfield.text != "" && confirmPasswordTextfield.text != "" && dateOfBirthTextfield.text != "")
    }
    
    // MARK: - Helper
  
    @objc func handleDatePicker(){
        dateOfBirthTextfield.text = datePicker.date.longDate()
    }

    @objc private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    //MARK: - Editing Mode
    private func EditingMode() {
        dateOfBirthTextfield.isUserInteractionEnabled = false
    }
    
    // MARK: - Show Calendar
    @IBAction func showCalendarPress(_ sender: UIButton) {
        
       getCalendar(sender) { (dateString, selectedDate) in
            self.dateOfBirthTextfield.text = dateString
            self.selectedDateOfBirth = selectedDate
        }
        
    }
    
    // MARK: - Navigation
    @IBAction func backBntPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func goToLoginPage(){
        let loginView = UIStoryboard.init(name: NavgationHelper.LoginScreen.StoryboardName, bundle: nil).instantiateViewController(identifier: NavgationHelper.LoginScreen.ControllerIdentifier)
        
        DispatchQueue.main.async {
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true, completion: nil)
        }
    } 

    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    private func getCalendar(_ bntClicked: UIButton, completion: @escaping (_ dateSelectedString: String, _ selectedDate: Date) -> Void) {
        let minDate = DatePickerHelper.shared.dateFrom(
            day: 01,
            month: 01,
            year: Calendar.current.component(.year, from: Date()) - 90)!
        let maxDate = DatePickerHelper.shared.dateFrom(
            day: Calendar.current.component(.day, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            year: Calendar.current.component(.year, from: Date()) - 15)!
    

        let today = Date()
        // Create picker object
        let datePicker = DatePicker()
        // Setup
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                
                completion(selectedDate.string(),selectedDate)
            }
        }
        // Display
         datePicker.show(in: self, on: bntClicked)
    }
    
}
