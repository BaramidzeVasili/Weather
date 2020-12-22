//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/18/20.


import UIKit
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Variables
    var window                                      : UIWindow?
    var storyboard                                  : UIStoryboard!
    let reachability                                = try! Reachability()
    var connectionAlertView                         : NoInternetView!
    var locationManager                             : LocationManager!
    var noLocationView                              : NoLocationView!

    //MARK: - Application functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initWindowAndStoryBoard()
        setLocation()
        addReachability()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        checkLocationPermission()
    }
    
    func initWindowAndStoryBoard(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.windowLevel = .normal
        window?.makeKeyAndVisible()
    }
    


    //MARK: - Location
    func setLocation(){
        locationManager = LocationManager()
        locationManager.initLocationManager()
    }
    
    func checkLocationPermission(){
        SettingsManager.shared.needUpdateLocation = true
        SettingsManager.shared.needsendError = true
        if self.noLocationView != nil {
            self.noLocationView.removeFromSuperview()
            self.noLocationView = nil
        }
        if locationManager.isLocationPermissionGranted(){
           // ჩართული აქვს მომხმარებელს მისამართის იდენთიფიკაცია
            locationManager.completion = { coordinate, error in
                if let coord = coordinate {
                    SettingsManager.shared.userCoordinate = coord
                }
            }
        }else{
            // არ აქვს ჩართული მისამართის იდენთიფიკაცია
            noLocationView = Bundle.main.loadNibNamed("NoLocationView", owner: nil, options: nil)![0] as! NoLocationView
            windowAddSubview(uiview: noLocationView)
        }
    }
    

    //MARK: - Internet Connection

    func addReachability(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            //თუ გადაფარებულია "ინტერნეტი არაა" მოვაშოროთ
            if connectionAlertView != nil {
                connectionAlertView.removeFromSuperview()
            }
            SettingsManager.shared.needUpdateLocation = true
            SettingsManager.shared.needsendError = true
        case .unavailable:
            connectionAlertView = (Bundle.main.loadNibNamed("NoInternetView", owner: nil, options: nil)![0] as! NoInternetView)
            windowAddSubview(uiview: connectionAlertView)
            
        case .none: break
        }
    }
    
    
    // for add alerts
    func windowAddSubview(uiview:UIView){
        uiview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        self.window?.addSubview(uiview)
        
        self.window?.addConstraint(NSLayoutConstraint(item: uiview, attribute: .trailing, relatedBy: .equal, toItem: self.window, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.window?.addConstraint(NSLayoutConstraint(item: uiview, attribute: .leading, relatedBy: .equal, toItem: self.window, attribute: .leading, multiplier: 1, constant: 0))

        self.window?.addConstraint(NSLayoutConstraint(item: uiview, attribute: .top, relatedBy: .equal, toItem: self.window, attribute: .top, multiplier: 1, constant: 0))

        self.window?.addConstraint(NSLayoutConstraint(item: uiview, attribute: .bottom, relatedBy: .equal, toItem: self.window, attribute: .bottom, multiplier: 1, constant: 0))
    }
}

