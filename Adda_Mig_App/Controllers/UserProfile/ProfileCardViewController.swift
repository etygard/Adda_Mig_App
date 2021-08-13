//
//  GeneralProfileViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-17.
//

import UIKit

struct Continent {
    static let name = ["Asia", "Africa", "North America", "South America", "Antarctica", "Europe"]
}

class ProfileCardViewController: UIViewController {
 
    var selectedItem: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Continent"
        // Do any additional setup after loading the view.
        print("<<<< ProfileCardViewController >>>>")
    }
    
    @IBAction func CareSliderBntPress(_ sender: UIButton) {
        
        let gotoStoryboard = UIStoryboard.init(name: "CardSlider", bundle: nil).instantiateViewController(identifier: "CardSlider")
        gotoStoryboard.modalPresentationStyle = .fullScreen
            self.present(gotoStoryboard, animated: true, completion: nil)
        
    } 
    
}


extension ProfileCardViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Continent.name.count \(String(Continent.name.count))")
        return Continent.name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardIdentifier", for: indexPath) as! ProfileCardCollectionViewCell
        cell.nameAndAge.text = Continent.name[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = Continent.name[indexPath.row]
       // performSegue(withIdentifier: "seguGotoContryScreen", sender: self)
    }

   //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   //        let countryVC = segue.destination as! CountryViewController
   //        countryVC.selectedContinent = (selectedItem!) as? String
   //    }
    
    
    
}

/*
 
 
 */
