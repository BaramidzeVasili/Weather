//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/20/20.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    //MARK: - Variables
    var locationManager             : CLLocationManager!
    var locationStatus              : NSString = "Not Started"
    var completion                  : ((CLLocationCoordinate2D?,String?) -> Void)?
    
    
    //MARK: - My functions
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
    }
    func calculateDistance(fromLocation: CLLocation?, toLocation: CLLocation?) -> CLLocationDistance {
        let distance = fromLocation?.distance(from: toLocation!)
        
        return distance!
    }
}

//MARK: - LocationDelegate Functions
extension LocationManager: CLLocationManagerDelegate{
    func isLocationPermissionGranted() -> Bool{
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if SettingsManager.shared.needsendError {
            SettingsManager.shared.needsendError = false
            completion?(nil,error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if SettingsManager.shared.needUpdateLocation {
            SettingsManager.shared.needUpdateLocation = false
            let locationArray = locations as Array
            let locationObj = locationArray.last as! CLLocation
            let coord = locationObj.coordinate
            completion?(coord,nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        SettingsManager.shared.needUpdateLocation = true
        SettingsManager.shared.needsendError = true
        var shouldIAllow = false
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLocationPermissionStatus"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
}
