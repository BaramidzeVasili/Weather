//
//  SettingsManager.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/21/20.
//

import UIKit
import CoreLocation

let weHaveCoordinateKey   = "com.WeatherApp.weHaveCoordinateKey"

class SettingsManager: NSObject {
    //MARK: - Variables
    static let shared                      = SettingsManager()
    let apiKey                             = "1acfac09711b7972ba86791be2115ae3"
    var cityName                           = ""
    var countryCode                        = ""
    var needUpdateLocation                 = true
    var needsendError                      = true
    var userCoordinate                     : CLLocationCoordinate2D!{
        willSet{
            updateUserData(coordinate: newValue)
        }
    }
    
    override init() {
        super.init()
    }
    
    //MARK: - Functions
    func updateUserData(coordinate: CLLocationCoordinate2D?){
        if coordinate != nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: weHaveCoordinateKey), object: nil, userInfo: ["Cooordinate": coordinate!])
        }
    }    
}
