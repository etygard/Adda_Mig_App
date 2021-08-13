//
//  DetailTableViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-26.
//

import UIKit


private let gradientLayer : CAGradientLayer = {
   
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.black.withAlphaComponent(0.01).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    return gradientLayer
}()

class DetailViewController: UITableViewController {

    @IBOutlet var ReviewListTableView: UITableView!
    @IBOutlet weak var backgroundPlaceholder: UIView!
    @IBOutlet weak var likeBnt: UIButton!
    @IBOutlet weak var disLikeBnt: UIButton!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var cityAndCountryLabel : UILabel!
    
     
    // MARK: - Form IBOutlet
    @IBOutlet weak var ageLabel: UILabel!
   // @IBOutlet weak var gendarLabel: UILabel!
   // @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    @IBOutlet weak var kindOfHelpLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var likeIcon: UIImageView!
    
    // MARK: - Vars
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = userId {
            getUserData()
            setGradientBackground()
            updateLikeButton()
            getNumberOfLikes()
        } else {
            dismissView()
        }
        
    }
    
    @IBAction func backBnt(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func likeBntPress(_ sender: UIButton) {
        LikesModel.switchUpdateLikedBetweenUnlike(userId: userId) { (isLiked) in
            if isLiked ?? false {
                self.updateLikedIcon(isLiked: false)
                LikesModel().saveDisLikeToUser(userId: self.userId)
            } else {
                self.updateLikedIcon(isLiked: true)
                LikesModel().saveLikeToUser(userId: self.userId)
            }
            self.getNumberOfLikes()
             
        }  
    }
    
    @IBAction func disLikeBntPress(_ sender: UIButton) {
        LikesModel().saveDisLikeToUser(userId: userId)
        updateLikedIcon(isLiked: false)
    }
    
    private func updateLikeButton(){
        if !userModel.currentUser()!.likedIdArray!.contains(userId) {
            updateLikedIcon(isLiked: false)
        } else {
            updateLikedIcon(isLiked: true)
        }
    }
    
//    private func updateLikedIcon(isLiked: Bool) {
//        if isLiked {
//            disLikeBnt.isHidden = false
//            likeBnt.isEnabled = false
//            likeIcon.image = UIImage(named: "icon-red-heart")
//        }else {
//            disLikeBnt.isHidden = true
//            likeBnt.isEnabled = true
//            likeIcon.image = UIImage(named: "icon-heart-black")
//        }
//        print(">> getNumberOfLikes >>")
//
//    }
    
    private func updateLikedIcon(isLiked: Bool) {
        disLikeBnt.isHidden = true
        if isLiked {
            likeBnt.setImage(UIImage(named: "icon-like"), for: .normal)
            likeIcon.image = UIImage(named: "icon-like")
        }else {
            likeBnt.setImage(UIImage(named: "icon-dislike"), for: .normal)
            likeIcon.image = UIImage(named: "icon-dislike")
        }
    }
    
    private func getNumberOfLikes(){
        LikesModel.numberOfLiks(userId: userId, completion: { (numberOfLikesText) in
            self.numberOfLikesLabel.text = (numberOfLikesText > 0) ? " \(numberOfLikesText) Likes" : " 0 Likes" 
        })
    }
    
    func getUserData(){
        FirebaseListener.shared.downloadSelectedUserFromFirebase(userId: userId) { (userData) in
            userData.getUserAvatarFromFirestore { (didSet) in
                
                self.nameLabel.text = userData.username
                //self.gendarLabel.text = ProfileCardHelper().getGendar(gendar: userData.gendar)
                //self.statusLabel.text = ProfileCardHelper().getStatus(status: userData.married)
                
                let aboutMe = ProfileCardHelper().getAboutMe(aboutme: userData.about)
                self.aboutLabel.text = aboutMe != "" ? aboutMe : ""
                
                let age = ProfileCardHelper().getAge(dateOfBirth: userData.dateOfBirth)
                self.ageLabel.text = age != "" ? age : ""
                
                let cityAndCountry = ProfileCardHelper().getCityAndCountry(city: userData.city, country: userData.country)
                self.cityAndCountryLabel.text = cityAndCountry != "" ? cityAndCountry : ""
                
                let lookingFor = ProfileCardHelper().getLookingFor(lookingFor: userData.lookingFor!)
                self.lookingForLabel.text = lookingFor != "" ? lookingFor : ""
                
                let kindOfHelp = ProfileCardHelper().getkindOfHelp(kindOfHelp: userData.kindOfHelp!)
                self.kindOfHelpLabel.text = kindOfHelp != "" ? kindOfHelp : ""
                
                
                self.jobLabel.text = userData.jobTitle
                self.educationLabel.text = userData.education
  
                self.avatarImageView.image = userData.avatar//?.circleMasked
            }
        }
        
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func setIconImage(icon: UIImageView , UIImageNamed : String) {
        icon.image = UIImage(named: UIImageNamed)
    }
    
    func setGradientBackground() {
        
        gradientLayer.removeFromSuperlayer()
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.cornerRadius = 9
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        gradientLayer.frame = self.backgroundPlaceholder.bounds

        self.backgroundPlaceholder.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Helper
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
//    private func saveLikeToUser(userId: String){
//        if let currentUser = userModel.currentUser() {
//            // check if currentUser didn't like the user
//            print(currentUser.likedIdArray!)
//            if !currentUser.likedIdArray!.contains(userId) {
//                currentUser.likedIdArray!.append(userId)
//                currentUser.updateCurrentUserInFireStore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
//                    print("Updateed current user with user", error?.localizedDescription ?? "")
//                }
//            }
//        }
//    }
 
}


