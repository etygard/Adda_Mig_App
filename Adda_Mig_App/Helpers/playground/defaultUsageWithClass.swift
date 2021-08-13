//
//  defaultUsageWithClass.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-20.
//
/*
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

 class ProfileTableViewController: UITableViewController {

     @IBOutlet weak var avatarImageView: UIImageView!
     @IBOutlet weak var profileCellBackgroundView: UITableViewCell!
     @IBOutlet weak var userNameLabel : UILabel!
     @IBOutlet weak var viewCellFooter: UIView!
     @IBOutlet weak var viewCellHeader: UIView!
     // MARK: - Form IBOutlet
     @IBOutlet weak var checkboxFemale: UIButton!
     @IBOutlet weak var checkboxMale: UIButton!
     @IBOutlet weak var checkboxSingle: UIButton!
     @IBOutlet weak var checkboxMarried: UIButton!
    
     @IBOutlet weak var dateOfBirthTextfield: UITextField!
     @IBOutlet weak var cityTextfield: UITextField!
     @IBOutlet weak var countryTextfield: UITextField!
     @IBOutlet weak var aboutTextfield: UITextField!
     @IBOutlet weak var jobTextfield: UITextField!
     @IBOutlet weak var educationTextfield: UITextField!
     
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
         
         maskRoundCorner()
         
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
 extension ProfileTableViewController {
     
     func maskRoundCorner() {
         UIHelper.setMaskedRoundOnBottomCorners(selectedView: profileCellBackgroundView, cornerRadius: 80)
         UIHelper.setMaskedRoundOnTopCorners(selectedView: viewCellHeader, cornerRadius: 40)
         UIHelper.setMaskedRoundOnBottomCorners(selectedView: viewCellFooter, cornerRadius: 40)
     }
     
     func setButtonBgImage(Bnt: UIButton , UIImageNamed : String) {
         Bnt.setBackgroundImage(UIImage(named: UIImageNamed), for: .normal)
     }
     
     func checkboxControl(_ checkboxSelected: UIButton) {
         
         if let identifier = checkboxSelected.accessibilityIdentifier {
             checkboxSelected.isSelected = !checkboxSelected.isSelected
             checkBoxValues[identifier] = checkboxSelected.isSelected
             
             if identifier == "gendar.female" && checkboxSelected.isSelected {
                 checkBoxValues["gendar.male"] = false
                 setButtonBgImage(Bnt: checkboxMale, UIImageNamed: "checkbox-empty")
             } else if identifier == "gendar.male" && checkboxSelected.isSelected {
                 checkBoxValues["gendar.female"] = false
                 setButtonBgImage(Bnt: checkboxFemale, UIImageNamed: "checkbox-empty")
            
             } else if identifier == "status.married" && checkboxSelected.isSelected {
                 checkBoxValues["gendar.single"] = false
                 setButtonBgImage(Bnt: checkboxSingle, UIImageNamed: "checkbox-empty")
             
             } else if identifier == "status.single" && checkboxSelected.isSelected {
                 checkBoxValues["gendar.married"] = false
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
 extension ProfileTableViewController {
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
         checkboxFemale.isUserInteractionEnabled = editingMode
         checkboxMale.isUserInteractionEnabled = editingMode
         checkboxSingle.isUserInteractionEnabled = editingMode
         checkboxMarried.isUserInteractionEnabled = editingMode
         
         dateOfBirthTextfield.isUserInteractionEnabled = editingMode
         cityTextfield.isUserInteractionEnabled = editingMode
         countryTextfield.isUserInteractionEnabled = editingMode
         aboutTextfield.isUserInteractionEnabled = editingMode
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
             loadUserData()
         }
     }
     
     //MARK: - LoadUserDada
     private func loadUserData() {
         
         let currentUser = userModel.currentUser()!
         FileStorage.downloadImage(imageUrl: currentUser.avatarLink) { (image) in
             
         }
         //TODO Textfiled
         userNameLabel.text = currentUser.username
         
 //        aboutTextfield.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
 //        //dateOfBirthTextfield.text = currentUser.dateOfBirth as? String
 //        cityTextfield.text = currentUser.city
 //        countryTextfield.text = currentUser.country
 //        jobTextfield.text = currentUser.jobTitle
 //        educationTextfield.text = currentUser.education
         
 //        switch currentUser.gendar {
 //        case "Female":
 //            setButtonBgImage(Bnt: checkboxFemale, UIImageNamed: "checkbox-checked")
 //        case "Male":
 //            setButtonBgImage(Bnt: checkboxMale, UIImageNamed: "checkbox-checked")
 //        default:
 //            print("Gendar: unknown")
 //        }
 //
 //        switch currentUser.married {
 //        case "Single":
 //            setButtonBgImage(Bnt: checkboxSingle, UIImageNamed: "checkbox-checked")
 //        case "Married":
 //            setButtonBgImage(Bnt: checkboxMarried, UIImageNamed: "checkbox-checked")
 //        default:
 //            print("Married: unknown")
 //        }
         
         
         avatarImageView.image = currentUser.avatar?.circleMasked
         
     }
     
     @objc func editUserData() {
         
         var gendar = "Unknown"
         let isFemale = checkBoxValues["gendar.female"] ?? false
         let isMale = checkBoxValues["gendar.male"] ?? false
         if isFemale {
             gendar = "Female"
         } else if isMale {
             gendar = "Male"
         }
         
         var married = "Unknown"
         let isSingle = checkBoxValues["status.single"] ?? false
         let isMarried = checkBoxValues["status.married"] ?? false
         if isSingle {
              married = "Single"
         } else if isMarried {
             married = "Married"
         }
         print(isSingle)
         print(isMarried)
       
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
                     kindOfHelp.append(key)
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
     }
     
 }

  
 // MARK: - GalleryController
 extension ProfileTableViewController: GalleryControllerDelegate {
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
 extension ProfileTableViewController {
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

 /*
  //
  //  FUser.swift
  //  Travel-And-Friends
  //
  //  Created by Waleerat Gottlieb on 2020-10-07.
  //

  import UIKit
  import Gallery
  import ProgressHUD

  class ProfileTableViewController: UITableViewController {

      //MARK: - IBOutlets
      
      @IBOutlet weak var profileCellBackgroundView: UIView!
      @IBOutlet weak var avatarImageView: UIImageView!
      @IBOutlet weak var aboutMeView: UIView!
      
      @IBOutlet weak var nameAgeLabel: UILabel!
      @IBOutlet weak var cityCountryLabel: UILabel!
      @IBOutlet weak var aboutMeTextView: UITextView!
      
      @IBOutlet weak var jobTextfield: UITextField!
      
      @IBOutlet weak var professionTextfield: UITextField!
      //@IBOutlet weak var genderTextfield: UITextField!
      @IBOutlet weak var gendarSecment: UISegmentedControl!
      
      @IBOutlet weak var cityTextfield: UITextField!
      @IBOutlet weak var countryTextfield: UITextField!
      @IBOutlet weak var heightTextfield: UITextField!
      @IBOutlet weak var lookingForTextfield: UITextField!
      
      //MARK: - Vars
      var editingMode = false
      var uploadingAvatar = true
      
      var avatarImage: UIImage?
      var gallery: GalleryController!
      
      var alertTextField: UITextField!
      
      
      //MARK: - ViewLifeCycle

      override func viewDidLoad() {
          super.viewDidLoad()

          overrideUserInterfaceStyle = .light
          
          setupBackgrounds()
          
          if FUser.currentUser() != nil {
              loadUserData()
              updateEditingMode()
          }
      }
      
      override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 0
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
      
      @objc func editUserData() {
          
          let user = FUser.currentUser()!
          
          user.about = aboutMeTextView.text
          user.jobTitle = jobTextfield.text ?? ""
          user.profession = professionTextfield.text ?? ""
          user.isMale = gendarSecment.selectedSegmentIndex == 0 ? true : false //genderTextfield.text == "Male"
          user.city = cityTextfield.text ?? ""
          user.country = countryTextfield.text ?? ""
          user.lookingFor = lookingForTextfield.text ?? ""
          user.height = Double(heightTextfield.text ?? "0") ?? 0.0
          
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
      }
      
      private func saveUserData(user: FUser) {
          
          user.saveUserLocally()
          user.saveUserToFireStore()
      }
      
      //MARK: - Setup
      private func setupBackgrounds() {
          
          profileCellBackgroundView.clipsToBounds = true
          profileCellBackgroundView.layer.cornerRadius = 100
          profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
          
          aboutMeView.layer.cornerRadius = 10
      }
      
      private func showSaveButton() {
          
          let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
          
          navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
      }
      
      //MARK: - LoadUserDada
      private func loadUserData() {
          
          let currentUser = FUser.currentUser()!
          
          FileStorage.downloadImage(imageUrl: currentUser.avatarLink) { (image) in
              
          }

          nameAgeLabel.text = currentUser.username + ", \(abs(currentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
          
          cityCountryLabel.text = currentUser.country + ", " + currentUser.city
          aboutMeTextView.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
          jobTextfield.text = currentUser.jobTitle
          professionTextfield.text = currentUser.profession
          //genderTextfield.text = currentUser.isMale ? "Male" : "Female"
          gendarSecment.selectedSegmentIndex = currentUser.isMale ? 0 : 1
          cityTextfield.text = currentUser.city
          countryTextfield.text = currentUser.country
          heightTextfield.text = "\(currentUser.height)"
          lookingForTextfield.text = currentUser.lookingFor
          avatarImageView.image = UIImage(named: "avatar")?.circleMasked

          avatarImageView.image = currentUser.avatar?.circleMasked
          
      }


      //MARK: - Editing Mode
      private func updateEditingMode() {
          
          aboutMeTextView.isUserInteractionEnabled = editingMode
          jobTextfield.isUserInteractionEnabled = editingMode
          professionTextfield.isUserInteractionEnabled = editingMode
          gendarSecment.isUserInteractionEnabled = editingMode
          cityTextfield.isUserInteractionEnabled = editingMode
          countryTextfield.isUserInteractionEnabled = editingMode
          heightTextfield.isUserInteractionEnabled = editingMode
          lookingForTextfield.isUserInteractionEnabled = editingMode
      }

      
      //MARK: - Helpers
      private func showKeyboard() {
          self.aboutMeTextView.becomeFirstResponder()
      }

      private func hideKeyboard() {
          self.view.endEditing(false)
      }
      
      
      
      //MARK: - Gallery
      
      private func showGallery(forAvatar: Bool) {
          
          uploadingAvatar = forAvatar
          
          self.gallery = GalleryController()
          self.gallery.delegate = self
          Config.tabsToShow = [.imageTab, .cameraTab]
          Config.Camera.imageLimit = forAvatar ? 1 : 10
          Config.initialTab = .imageTab
          
          self.present(gallery, animated: true, completion: nil)
      }


      
      //MARK: - AlertController
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
      
      //MARK: - Change user info
      
      private func updateUserWith(value: String) {
          
          if alertTextField.text != "" {
              
              value == "Email" ? changeEmail() : changeUserName()
          } else {
              ProgressHUD.showError("\(value) is empty")
          }
      }

      
      

      //MARK: - LogOut
      
      private func logOutUser() {
          
          FUser.logOutCurrentUser { (error) in
              
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
  }


  extension ProfileTableViewController: GalleryControllerDelegate {
      
      
      func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
          
          if images.count > 0 {
              
              if uploadingAvatar {
                  
                  images.first!.resolve { (icon) in
                      
                      if icon != nil {
                          
                          self.editingMode = true
                          self.showSaveButton()
                          
                          self.avatarImageView.image = icon?.circleMasked
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

  */

 */

import Foundation


class myModel{
    
    var email: String
    var username: String
    
    var userDictionary: NSDictionary {
        return NSDictionary(objects: [self.email,self.username],
                            forKeys: [kEMAIL as NSCopying, kUSERNAME as NSCopying])
    }
    
    //MARK: - Inits
    init(_email: String, _username: String) {
        email = _email
        username = _username
    }
    
    
    init(_dictionary: NSDictionary) {
        email = _dictionary[kEMAIL] as? String ?? ""
        username = _dictionary[kUSERNAME] as? String ?? ""
    }
    // MARK: - Set
    class func setData(){
        let userData = myModel.init(_email: "waleerat.gottlieb@gmail.com", _username: "Lee")
        userData.saveUserLocally()
    }
    
    func saveUserLocally() {
        print("set defaultUsage : OK ")
        userDefaults.setValue(self.userDictionary as! [String : Any], forKey: "myInfo")
        userDefaults.setValue("ON", forKey: "Music")
        userDefaults.synchronize()
    }

    // MARK: - Get
    class func getdata(){
        if let user = userDefaults.object(forKey: "myInfo") {
            print("get defaultUsage > ")
            print(user)
        }
        if let musicOption = userDefaults.object(forKey: "Music") {
            print("get musicOption > ")
            print(musicOption)
        }
    }
}
