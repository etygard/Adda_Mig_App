//
//  MapSearchVC.swift
//  Testing-MapsSearch
//
//  Created by Demo on 8/2/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit
import CoreLocation

class MapSearchViewController: UIViewController {

    

    @IBOutlet weak var tableView: UITableView!
    
    private var searchController:UISearchController = UISearchController()
    
    private let manager = CLLocationManager()

    let dataSourece = MapDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchController =  UISearchController(searchResultsController:nil )
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchController.searchBar.delegate = dataSourece
        searchController.isActive = true
        tableView.tableHeaderView = searchController.searchBar 
        definesPresentationContext = true
        
        title = "Location Search"
        
        dataSourece.delegate = self
        
        tableView.dataSource = dataSourece
        tableView.delegate = dataSourece
        
        manager.delegate = dataSourece
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            
            manager.requestWhenInUseAuthorization()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension MapSearchViewController: MapDataSourceDelegate{
    func refreshData() {
        self.tableView.reloadData()
    }
}



