//
//  DashboardViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-19.
//

import UIKit

class DashboardViewController: UIViewController
{
    
    @IBOutlet weak var profileListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nibname : file xib name
        profileListTableView.register(UINib(nibName: "DashboardViewCell", bundle: nil), forCellReuseIdentifier: "DashboardListCell")
    }
     
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardListCell", for: indexPath) as! DashboardViewCell
        cell.titleLabel.text = "Walerat"
        cell.detailsLabel.text = "I want job"
        cell.mainImageView.image = UIImage(named: "user1")?.circleMasked
        cell.postMessage.text = "Post Message"
        return cell
    }
    

}
