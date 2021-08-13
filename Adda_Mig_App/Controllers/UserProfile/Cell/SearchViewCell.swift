//
//  SearchViewCell.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-24.
//

import UIKit

 

class SearchViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ProfileView: UIView!
    @IBOutlet weak var commsView: UIView!
    
    @IBOutlet weak var viewProfileBnt: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var imagePorofileImageView: UIImageView!
    @IBOutlet weak var CityAndCountryLabel: UILabel!
    @IBOutlet weak var LookingForLabel: UILabel!
    @IBOutlet weak var kindOfHelp: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    //@IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var isLikeBnt: UIButton!
    
    var searchVC : SearchViewController?
    var userDetailVC : DetailViewController?
    
    var userId:String = ""
    var numberOfLikes = 0
    // MARK: - Vars
    
    var ProfileCardCell: ProfileCard? {
        didSet {
            if let profile = ProfileCardCell {
                userId = profile.userId
                viewProfileBnt.accessibilityIdentifier = profile.userId
                nameLabel.text = profile.name
                ageLabel.text = profile.age
                imagePorofileImageView.image = profile.profileImage?.circleMasked
                CityAndCountryLabel.text = profile.cityAndCountry
                LookingForLabel.text = profile.lookingFor
                kindOfHelp.text = profile.kindOfHelp
                //ratingLabel.text = String(profile.rating)
                
                numberOfLikes = profile.likedIdArray.count
                numberOfLikesLabel.text = (numberOfLikes > 0) ? " \(numberOfLikes) Likes" : " 0 Likes"
                if profile.likedIdArray.contains(userModel.currentId()) {
                    self.updateLikedIcon(isLiked: true)
                } else {
                    self.updateLikedIcon(isLiked: false)
                }
                 
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func showProfileBntPress(_ sender: AnyObject) {
        searchVC!.goToNextScene(userId: userId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIHelper.setRadius(selectedView: ProfileView, cornerRadius: 10)
        cardView.applyShadow(radius: 5, opacity: 0.1, offset: CGSize(width: 0, height: 2))
    }
    
    @IBAction func likeBntPress(_ sender: UIButton) {
        LikesModel.switchUpdateLikedBetweenUnlike(userId: userId) { (isLiked) in
            if isLiked ?? false {
                LikesModel().saveDisLikeToUser(userId: self.userId)
                self.updateLikedIcon(isLiked: false)
            } else {
                LikesModel().saveLikeToUser(userId: self.userId)
                self.updateLikedIcon(isLiked: true)
            }
            self.getNumberOfLikes()
        }
       
    }
    
    func updateLikedIcon(isLiked: Bool) {
        if isLiked {
            isLikeBnt.setImage(UIImage(named: "icon-like"), for: .normal)
        }else {
            isLikeBnt.setImage(UIImage(named: "icon-dislike"), for: .normal)
        }
    }
    
    @IBAction func chatBntPress(_ sender: UIButton) {
        print("Let's Chat")
    }
    
    private func getNumberOfLikes(){
        LikesModel.numberOfLiks(userId: userId, completion: { (numberOfLikes) in
            self.numberOfLikesLabel.text = (numberOfLikes > 0) ? " \(numberOfLikes) Likes" : " 0 Likes"
        })
    }
    
}
