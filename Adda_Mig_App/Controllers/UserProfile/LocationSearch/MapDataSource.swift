//
//  MapDataSource.swift
//  Testing-MapsSearch
//
//  Created by Demo on 8/2/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit
import MapKit

protocol MapDataSourceDelegate: class{
    
    func refreshData()
    

}


class MapDataSource:NSObject{
    
    private var search:MKLocalSearch? = nil
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var places = [MKLocalSearchCompletion]()
    
    weak var delegate:MapDataSourceDelegate?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        
//        search = MKLocalSearch.init(request)
    }
    
    func locationCount() -> Int {
        return places.count
    }
    
    func locationAt(index:IndexPath) -> MKLocalSearchCompletion{
        
        return places[index.row]
        
    }
    
    
 
    
    
}

extension MapDataSource:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch  status {
        case .authorizedAlways, .authorizedWhenInUse:
            
            manager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        
        searchCompleter.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
        
        
    }
    
 }
extension MapDataSource:UITableViewDataSource{
    
     func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        let count = locationCount()
     
        return count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        let item = locationAt(index: indexPath)
        
        cell.textLabel?.text = item.title
   
        cell.detailTextLabel?.text = item.subtitle
       
        return cell
    }

}

extension MapDataSource:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = locationAt(index: indexPath)
        print("-----------")
        print(item.subtitle)
        print("-----------")
        let searchRequest = MKLocalSearch.Request()

        //searchRequest.naturalLanguageQuery = "coffee";
        
        // Set the region to an associated map view's region.
        //searchRequest.region = myMapView.region
        
        //searchRequest.naturalLanguageQuery = item.subtitle
        let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
          
            guard let response = response else {return}
            guard let item = response.mapItems.first else {return}
            print(item)
            /*
           item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            */
        }
    }
}


extension MapDataSource:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        places = completer.results
        
        delegate?.refreshData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        
    }
}


extension MapDataSource:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        
    }
}
