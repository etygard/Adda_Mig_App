//
//  NotificationViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-28.
//

import UIKit
import ProgressHUD

class NotificationsViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars
    var allLikes: [LikeObject] = []
    var allUsers: [userModel] = []
    
    // MARK: - viewLiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadLikes()
    }
    
    private func downloadLikes() {
        ProgressHUD.show()
        LikesModel.downloadUserLikes { (allUserIds) in
            if allUserIds.count > 0 {
                print("Likes > \(allUserIds.count)")
            } else {
                print("No Likes > \(allUserIds.count)")
                ProgressHUD.dismiss()
            }
        }
        ProgressHUD.dismiss()
    }
     
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension NotificationsViewController: UITableViewDelegate {
    
}
