//
//  ProfileTableViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-18.
//

import UIKit
import Gallery
import ProgressHUD
import DatePicker

class SettingViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileCellBackgroundView: UITableViewCell!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet var ProfileTableView: UITableView!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var namdAndAgeLabel : UILabel!
    @IBOutlet weak var cityAndCountryLabel: UILabel!
    
    @IBOutlet weak var viewCellFooter: UIView!
    @IBOutlet weak var viewCellHeader: UIView!
    // MARK: - Form IBOutlet
    @IBOutlet weak var checkboxFemale: UIButton!
    @IBOutlet weak var checkboxMale: UIButton!
    @IBOutlet weak var checkboxSingle: UIButton!
    @IBOutlet weak var checkboxMarried: UIButton!
    
    @IBOutlet weak var checkboxNeedHelp: UIButton!
    @IBOutlet weak var checkboxWantJob: UIButton!
    @IBOutlet weak var checkboxkindOfHelpOne: UIButton!
    @IBOutlet weak var checkboxkindOfHelpTwo: UIButton!
    @IBOutlet weak var checkboxkindOfHelpThree: UIButton!
    @IBOutlet weak var checkboxkindOfHelpFour: UIButton!
    
   
    @IBOutlet weak var dateOfBirthTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var aboutTextfield: UITextView!
    @IBOutlet weak var jobTextfield: UITextField!
    @IBOutlet weak var educationTextfield: UITextField!
    
    // MARK: - IBOurlet Form
    @IBOutlet weak var suggessUpdateProfileLabel: UILabel!
    @IBOutlet weak var profileHeaderLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var gendarLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var singleLabel: UILabel!
    @IBOutlet weak var marriedLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var lookingForHeaderLabel: UILabel!
    @IBOutlet weak var lookingForHelpLabel: UILabel!
    @IBOutlet weak var lookingForJobLabel: UILabel!
    
    @IBOutlet weak var kindOfHelpHeaderLabel: UILabel!
    @IBOutlet weak var kindOfHelpOneLabel: UILabel!
    @IBOutlet weak var KineOfHelpTwoLabel: UILabel!
    @IBOutlet weak var KindOfHelpThreeLabel: UILabel!
    @IBOutlet weak var KindOfHelpFourLabel: UILabel!
    @IBOutlet weak var GeneralQuestionHeaderLabel: UILabel!
    @IBOutlet weak var currentJobLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    
    
    // MARK: - Form Vars
    var checkBoxValues = [String: Bool]()
    var selectedDateOfBirth: Date?
    
    
    //MARK: - Vars
    var editingMode = false
    var uploadingAvatar = true
    
    var avatarImage: UIImage?
    var gallery: GalleryController!
    var alertTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextLabel()
        maskRoundCorner()
       // avatarImageView.applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
       
        
        if userModel.currentUser() != nil {
            loadUserData()
            updateEditingMode()
        }
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showEditOptions()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        showPictureOptions()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editingMode.toggle()
        updateEditingMode()
        
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    
    
    @IBAction func showCalendarPress(_ sender: UIButton) {
        getCalendar(sender) { (dateString, selectedDate) in
             self.dateOfBirthTextfield.text = dateString
             self.selectedDateOfBirth = selectedDate
         }
    }
    
    @IBAction func checkBoxPress(_ sender: UIButton) {
        checkboxControl(sender)
    }
   
    
    //MARK: - LogOut
    // Logout current user
    private func logOutUser() {
         
        userModel.logOutCurrentUser { (error) in
            
            if error == nil {
                
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
                
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
        
    }
   
    
    //MARK: - Setup
    private func showSaveButton() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    //MARK: - Helpers
    private func showKeyboard() {
        self.aboutTextfield.becomeFirstResponder()
    }

    private func hideKeyboard() {
        self.view.endEditing(false)
    }
    
    private func showGallery(forAvatar: Bool) {
        uploadingAvatar = forAvatar
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = forAvatar ? 1 : 10
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
    }
}

// MARK: - Extension FormControl
extension SettingViewController {
    
    func maskRoundCorner() {
        UIHelper.setMaskedRoundOnBottomCorners(selectedView: profileCellBackgroundView, cornerRadius: 80)
        UIHelper.setRadius(selectedView: aboutView, cornerRadius: 20)
        UIHelper.setMaskedRoundOnTopCorners(selectedView: viewCellHeader, cornerRadius: 40)
        UIHelper.setMaskedRoundOnBottomCorners(selectedView: viewCellFooter, cornerRadius: 40)
    }
    
    func setButtonBgImage(Bnt: UIButton , UIImageNamed : String) {
        Bnt.setBackgroundImage(UIImage(named: UIImageNamed), for: .normal)
        Bnt.isSelected = (UIImageNamed == "checkbox-checked") ?  true : false
    }
    
    func checkboxControl(_ checkboxSelected: UIButton) {
            
        if let identifier = checkboxSelected.accessibilityIdentifier {
            checkboxSelected.isSelected = !checkboxSelected.isSelected
            checkBoxValues[identifier] = checkboxSelected.isSelected
            
            if identifier == "gendar.Female" && checkboxSelected.isSelected {
                checkBoxValues["gendar.Male"] = false
                setButtonBgImage(Bnt: checkboxMale, UIImageNamed: "checkbox-empty")
            } else if identifier == "gendar.Male" && checkboxSelected.isSelected {
                checkBoxValues["gendar.Female"] = false
                setButtonBgImage(Bnt: checkboxFemale, UIImageNamed: "checkbox-empty")
           
            } else if identifier == "status.Married" && checkboxSelected.isSelected {
                checkBoxValues["status.Single"] = false
                setButtonBgImage(Bnt: checkboxSingle, UIImageNamed: "checkbox-empty")
            
            } else if identifier == "status.Single" && checkboxSelected.isSelected {
                checkBoxValues["status.Married"] = false
                setButtonBgImage(Bnt: checkboxMarried, UIImageNamed: "checkbox-empty")
            }
            
            if checkBoxValues[identifier]! {
                setButtonBgImage(Bnt: checkboxSelected, UIImageNamed: "checkbox-checked")
            } else {
                setButtonBgImage(Bnt: checkboxSelected, UIImageNamed: "checkbox-empty")
                
            }
        }
    }
}

// MARK: - Extension update/load data
extension SettingViewController {
    //MARK: - Change user info
    private func updateUserWith(value: String) {
        
        if alertTextField.text != "" {
            
            value == "Email" ? changeEmail() : changeUserName()
        } else {
            ProgressHUD.showError("\(value) is empty")
        }
    }

    
    //MARK: - Editing Mode
    private func updateEditingMode() {
        
        calendarButton.isUserInteractionEnabled = editingMode
        checkboxFemale.isUserInteractionEnabled = editingMode
        checkboxMale.isUserInteractionEnabled = editingMode
        checkboxSingle.isUserInteractionEnabled = editingMode
        checkboxMarried.isUserInteractionEnabled = editingMode
        
        checkboxNeedHelp.isUserInteractionEnabled = editingMode
        checkboxWantJob.isUserInteractionEnabled = editingMode
        checkboxkindOfHelpOne.isUserInteractionEnabled = editingMode
        checkboxkindOfHelpTwo.isUserInteractionEnabled = editingMode
        checkboxkindOfHelpThree.isUserInteractionEnabled = editingMode
        checkboxkindOfHelpFour.isUserInteractionEnabled = editingMode
        
        aboutTextfield.isUserInteractionEnabled = editingMode
        dateOfBirthTextfield.isUserInteractionEnabled = editingMode
        cityTextfield.isUserInteractionEnabled = editingMode
        countryTextfield.isUserInteractionEnabled = editingMode
        jobTextfield.isUserInteractionEnabled = editingMode
        educationTextfield.isUserInteractionEnabled = editingMode
    }
    
    // MARK: - Save Data
    private func saveUserData(user: userModel) {
        user.saveUserLocally()
        user.saveUserToFireStore()
    }
    
    private func changeEmail() {
        
        userModel.currentUser()?.updateUserEmail(newEmail: alertTextField.text!, completion: { (error) in
            
            if error == nil {
                
                if let currentUser = userModel.currentUser() {
                    currentUser.email = self.alertTextField.text!
                    self.saveUserData(user: currentUser)
                    ProgressHUD.showSuccess("Save!", image: UIImage(named: "save-icon"), interaction: true)
                }

                ProgressHUD.showSuccess("Success!")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        })

    }
    
    private func changeUserName() {

        if let currentUser = userModel.currentUser() {
            currentUser.username = alertTextField.text!
            
            saveUserData(user: currentUser)
            ProgressHUD.showSuccess("Save!", image: UIImage(named: "save-icon"), interaction: true)
            loadUserData()
           
        }
    }
    
    //MARK: - LoadUserDada
    private func loadUserData() {
        
        let currentUser = userModel.currentUser()!
        FileStorage.downloadImage(imageUrl: currentUser.avatarLink) { (image) in
            
        }
         
        namdAndAgeLabel.text = currentUser.username + ", \(abs(currentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        cityAndCountryLabel.text = currentUser.country + ", " + currentUser.city
        
        namdAndAgeLabel.text = currentUser.username
        aboutTextfield.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
        dateOfBirthTextfield.text = currentUser.dateOfBirth.longDate()
        selectedDateOfBirth = currentUser.dateOfBirth
        cityTextfield.text = currentUser.city
        countryTextfield.text = currentUser.country
        jobTextfield.text = currentUser.jobTitle
        educationTextfield.text = currentUser.education
        
        // -- Gendar
        switch currentUser.gendar {
        case "Female":
            setButtonBgImage(Bnt: checkboxFemale, UIImageNamed: "checkbox-checked")
            checkBoxValues["gendar.Female"] = true
        case "Male":
            setButtonBgImage(Bnt: checkboxMale, UIImageNamed: "checkbox-checked")
            checkBoxValues["gendar.Male"] = true
        default:
            print("Gendar: unknown")
        }
        // -- Maired Status
        switch currentUser.married {
        case "Single":
            setButtonBgImage(Bnt: checkboxSingle, UIImageNamed: "checkbox-checked")
            checkBoxValues["status.Single"] = true
        case "Married":
            setButtonBgImage(Bnt: checkboxMarried, UIImageNamed: "checkbox-checked")
            checkBoxValues["status.Married"] = true
        default:
            print("Married: unknown")
        }
        // -- lookingFor
        if let lookingFor = currentUser.lookingFor {
            for (value) in lookingFor {
                switch value {
                case "Job":
                    setButtonBgImage(Bnt: checkboxWantJob, UIImageNamed: "checkbox-checked")
                    checkBoxValues["lookingFor.Job"] = true
                case "Help":
                    setButtonBgImage(Bnt: checkboxNeedHelp, UIImageNamed: "checkbox-checked")
                    checkBoxValues["lookingFor.Help"] = true
                default:
                    print("No selected")
                }
            }
        }
        // -- kindOfHelp
        
        
        if let kindOfHelp = currentUser.kindOfHelp {
            for (value) in kindOfHelp {
                switch value {
                case profile.kindOfHelpOne:
                    setButtonBgImage(Bnt: checkboxkindOfHelpOne, UIImageNamed: "checkbox-checked")
                    checkBoxValues["kindOfHelp.kindOfHelpOne"] = true
                case profile.KineOfHelpTwo:
                    setButtonBgImage(Bnt: checkboxkindOfHelpTwo, UIImageNamed: "checkbox-checked")
                    checkBoxValues["kindOfHelp.kindOfHelpTwo"] = true
                case profile.KindOfHelpThree:
                    setButtonBgImage(Bnt: checkboxkindOfHelpThree, UIImageNamed: "checkbox-checked")
                    checkBoxValues["kindOfHelp.kindOfHelpThree"] = true
                case profile.KindOfHelpFour:
                    setButtonBgImage(Bnt: checkboxkindOfHelpFour, UIImageNamed: "checkbox-checked")
                    checkBoxValues["kindOfHelp.kindOfHelpFour"] = true
                default:
                    print("No selected")
                }
            }
        }
        avatarImageView.image = currentUser.avatar?.circleMasked
        
    }
    
    @objc func editUserData() {
        
        var gendar = "Unknown"
        let isFemale = checkBoxValues["gendar.Female"] ?? false
        let isMale = checkBoxValues["gendar.Male"] ?? false
        if isFemale {
            gendar = "Female"
        } else if isMale {
            gendar = "Male"
        }
        
        var married = "Unknown"
        let isSingle = checkBoxValues["status.Single"] ?? false
        let isMarried = checkBoxValues["status.Married"] ?? false
        if isSingle {
             married = "Single"
        } else if isMarried {
            married = "Married"
        }
      
        var lookingFor: [String] = []
        var kindOfHelp: [String] = []

        for (dictionary , value) in checkBoxValues {
            let field = dictionary.components(separatedBy: ".").first!
            let key = dictionary.components(separatedBy: ".").last!
            
            if field == "lookingFor" {
                if value {
                    lookingFor.append(key)
                }
            }
            if field == "kindOfHelp" {
                if value {
                    kindOfHelp.append(profileForm.kindOfHelp[key]!)
                }
            }
        }
        
        let user = userModel.currentUser()!
        user.dateOfBirth = selectedDateOfBirth ?? Date(timeIntervalSince1970: 0)
        user.gendar = gendar
        user.city = cityTextfield.text ?? ""
        user.country = countryTextfield.text ?? ""
        user.lookingFor = lookingFor
        user.kindOfHelp = kindOfHelp
        user.married = married
        user.jobTitle = jobTextfield.text ?? ""
        user.education = educationTextfield.text ?? ""
        
        if avatarImage != nil {
            uploadAvatar(avatarImage!) { (avatarLink) in
                
                user.avatarLink = avatarLink ?? ""
                user.avatar = self.avatarImage
                
                self.saveUserData(user: user)
                self.loadUserData()
            }
            
        } else {
           //save
            saveUserData(user: user)
            loadUserData()
        }
        
        editingMode = false
        updateEditingMode()
        showSaveButton()
        ProgressHUD.showSuccess("Save!", image: UIImage(named: "save-icon"), interaction: true)
        // goto top screen
        //self.ProfileTableView.scrollToNearestSelectedRow(at: .top, animated: true)
    }
    
}
 
// MARK: - GalleryController
extension SettingViewController: GalleryControllerDelegate {
    //MARK: - FileStorage
    private func uploadAvatar(_ image: UIImage, completion: @escaping (_ avatarLink: String?)-> Void) {
        
        ProgressHUD.show()
        
        let fileDirectory = "Avatars/_" + userModel.currentId() + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            
            ProgressHUD.dismiss()
            FileStorage.saveImageLocally(imageData: image.jpegData(compressionQuality: 0.8)! as NSData, fileName: userModel.currentId())
            completion(avatarLink)
        }
        
    }

    
    private func uploadImages(images: [UIImage?]) {
        
        ProgressHUD.show()

        FileStorage.uploadImages(images) { (imageLinks) in
            
            ProgressHUD.dismiss()

            let currentUser = userModel.currentUser()!
            
            currentUser.imageLinks = imageLinks
            
            self.saveUserData(user: currentUser)
        }
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            if uploadingAvatar {
                
                images.first!.resolve { (icon) in
                    
                    if icon != nil {
                        self.editingMode = true
                        self.showSaveButton()
                        
                        self.avatarImageView.image = icon?.circleMasked ?? UIImage(named: "avatar")
 
                        self.avatarImage = icon
                    } else {
                        ProgressHUD.showError("Couldn't select image!")
                    }
                }
                
            } else {
                
                Image.resolve(images: images) { (resolvedImages) in
                   self.uploadImages(images: resolvedImages)
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Alert Menu Menus
extension SettingViewController {
     
    func setTextLabel(){
        suggessUpdateProfileLabel.text = profile.suggessUpdateProfile
        profileHeaderLabel.text = profile.profileHeader
        aboutMeLabel.text = profile.aboutMe
        birthdayLabel.text = profile.birthday
        gendarLabel.text = profile.gendar
        maleLabel.text = profile.male
        femaleLabel.text = profile.female
        statusLabel.text = profile.status
        singleLabel.text = profile.single
        marriedLabel.text = profile.married
        cityLabel.text = profile.city
        countryLabel.text = profile.country
        
        lookingForHeaderLabel.text = profile.lookingForHeader
        lookingForHelpLabel.text = profile.lookingForHelp
        lookingForJobLabel.text = profile.lookingForJob
       
        kindOfHelpHeaderLabel.text = profile.kindOfHelpHeader
        kindOfHelpOneLabel.text = profile.kindOfHelpOne
        KineOfHelpTwoLabel.text = profile.KineOfHelpTwo
        KindOfHelpThreeLabel.text = profile.KindOfHelpThree
        KindOfHelpFourLabel.text = profile.KindOfHelpFour
        GeneralQuestionHeaderLabel.text = profile.GeneralQuestionHeader
        currentJobLabel.text = profile.currentJob
        educationLabel.text = profile.education
    }

    // Camera
    private func showPictureOptions() {
        
        let alertController = UIAlertController(title: "Upload Picture", message: "You can change your Avatar or upload more pictures.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }

    //  Alert Setting Controller
    private func showEditOptions() {
        
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to edit sensitive information about your account.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            
            self.showChangeField(value: "Email")
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (alert) in
            
            self.showChangeField(value: "Name")
        }))
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            
            self.logOutUser()
        }))

        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showChangeField(value: String) {
        
        let alertView = UIAlertController(title: "Updating \(value)", message: "Please write your \(value)", preferredStyle: .alert)
        
        alertView.addTextField { (textField) in
            self.alertTextField = textField
            self.alertTextField.placeholder = "New \(value)"
        }
        
        alertView.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { (action) in
            
            self.updateUserWith(value: value)
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
