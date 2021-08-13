//
//  HomeViewController.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-17.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var countyPickerView: UIPickerView!
    
    var objectArray = [countiesObjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
          self.countyPickerView.delegate = self
          self.countyPickerView.dataSource = self
       
        for (key, value) in counties {
            print("\(key) -> \(value)")
            objectArray.append(countiesObjects(sectionName: key, sectionObjects: value))
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return objectArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return objectArray[component].sectionObjects.count
    }
 
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)  -> String? {
        return objectArray[component].sectionObjects[row]
        
    }
    
 
     
}
