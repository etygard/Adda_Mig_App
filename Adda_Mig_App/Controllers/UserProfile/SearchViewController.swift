//
//  SearchViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-24.
//

import UIKit
import Firebase
import ProgressHUD

class SearchViewController: UIViewController {
    
    var window: UIWindow?
    
    private var userObjects: [userModel] = []
    private var ProfileCardRows: [ProfileCard] = []
    // for Query profile
    var lastDocumentSnapshot: DocumentSnapshot?
    var isInitialLoad = true
    var showReserve = false
    var initialLoadNumber = 20
    
    var cityAndCountry = ""
    var profileAge = 0
    
    var selectedUserId = ""

    
    @IBOutlet weak var profileListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nibname : file xib name
        profileListTableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
        
        downloadInitialUsers()
    }
    
    //MARK: - DownloadUsers
    private func downloadInitialUsers() {
        let cardHelper = ProfileCardHelper()
        ProgressHUD.show()
        
        FirebaseListener.shared.downloadUsersFromFirebase(isInitialLoad: isInitialLoad, limit: initialLoadNumber, lastDocumentSnapshot: lastDocumentSnapshot) { (allUsers, snapshot) in
            
            if allUsers.count == 0 {
                ProgressHUD.dismiss()
            }
          
            self.lastDocumentSnapshot = snapshot
            self.isInitialLoad = false
            self.userObjects = allUsers
            
            for user in allUsers {
                user.getUserAvatarFromFirestore { (didSet) in
                    
                    let profileCard = ProfileCard(
                        userId: user.objectId,
                        name: user.username,
                        age: cardHelper.getAge(dateOfBirth: user.dateOfBirth),
                        profileImage: user.avatar,
                        cityAndCountry: cardHelper.getCityAndCountry(city: user.city, country: user.country),
                        lookingFor: cardHelper.getLookingFor(lookingFor: user.lookingFor!),
                        kindOfHelp: cardHelper.getkindOfHelp(kindOfHelp: user.kindOfHelp!),
                        likedIdArray: user.likedIdArray!,
                        rating: "2.0"
                    )

                    self.ProfileCardRows.append(profileCard)
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        self.profileListTableView.reloadData()
                        
                    }
                }
            }
            
            print("initial \(allUsers.count) received")
            self.downloadMoreUsersInBackground()
        }
        
    }
    
    private func downloadMoreUsersInBackground() {
        
        FirebaseListener.shared.downloadUsersFromFirebase(isInitialLoad: isInitialLoad, limit: 1000, lastDocumentSnapshot: lastDocumentSnapshot) { (allUsers, snapshot) in
            
            self.lastDocumentSnapshot = snapshot
            
            self.userObjects += allUsers
            
            for user in allUsers {
                user.getUserAvatarFromFirestore { (didSet) in
                    self.userObjects.append(user)
                }
            }
        }
    }
    
    func goToNextScene(userId: String) {
        let story = UIStoryboard(name: NavgationHelper.UserProfileScreen.StoryboardName, bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: NavgationHelper.UserProfileScreen.ControllerIdentifier) as! DetailViewController
        vc.userId = userId
        
        present(vc, animated: true, completion: nil)
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileCardRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchViewCell
        cell.searchVC = self
        cell.ProfileCardCell = ProfileCardRows[indexPath.row] // Test
        
        if indexPath.row % 2 == 0 {
            cell.ProfileView.backgroundColor = UIColor(named: "profileCard-needHelp")
        } else {
            cell.ProfileView.backgroundColor = UIColor(named: "profileCard-needJob")
        }
        
        return cell
    }
    
     

}
