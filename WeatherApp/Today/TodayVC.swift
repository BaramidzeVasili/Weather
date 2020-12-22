//
//  TodayVC.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/19/20.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class TodayVC: UIViewController{
    //MARK: - IBOutlets
    @IBOutlet weak var topColourfullView                    : UIView!
    @IBOutlet weak var topViewTopConstraint                 : NSLayoutConstraint!
    @IBOutlet weak var currentLocationContainerView         : UIView!
    @IBOutlet weak var currentLocation                      : UILabel!
    @IBOutlet weak var temperatureLbl                       : UILabel!
    @IBOutlet weak var dayDescriptionLbl                    : UILabel!
    @IBOutlet weak var conditionImage                       : UIImageView!
    
    @IBOutlet weak var precipitationLbl                     : UILabel!
    @IBOutlet weak var windSpeedLbl                         : UILabel!
    @IBOutlet weak var windDirectionLbl                     : UILabel!
    @IBOutlet weak var hpaLbl                               : UILabel!
    @IBOutlet weak var humidityLbl                          : UILabel!
    
    @IBOutlet weak var componentsContainerView              : UIView!
    @IBOutlet weak var secondComponentHorizontalConstraint  : NSLayoutConstraint!
    @IBOutlet weak var topSeparatorView                     : UIView!
    @IBOutlet weak var fourthComponentHorizontalConstraint  : NSLayoutConstraint!
    @IBOutlet weak var bottomSeparatorView                  : UIView!
    @IBOutlet weak var shareBtnBottomConstraint             : NSLayoutConstraint!
    @IBOutlet weak var indicator                            : UIActivityIndicatorView!
    
    //MARK: - Variables
    var todayShapeLayer                     = CAShapeLayer()
    
    //MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesign()
        addObservers()
        SettingsManager.shared.needsendError = true
        SettingsManager.shared.needUpdateLocation = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        applyDarkOrLightMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDarkOrLightMode()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            changeToLandscape()
        } else {
            changeToPortrait()
        }
    }
    //MARK: - My Functions
    //MARK: Notifications
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(getDataWithCoordinates(Notification: )), name: NSNotification.Name(rawValue: weHaveCoordinateKey), object: nil)
    }
    
    @objc func getDataWithCoordinates(Notification: Notification){
        guard let coord = Notification.userInfo!["Cooordinate"] as! CLLocationCoordinate2D? else { return }
        getData(coordinate: coord)
    }
    
    //MARK: location functions
    func getData(coordinate: CLLocationCoordinate2D){
        indicator.startAnimating()
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&APPID=\(SettingsManager.shared.apiKey)&units=metric", method: .get, parameters: [:], encoding: URLEncoding.httpBody,headers: nil).responseJSON { (response) in
            self.indicator.stopAnimating()
            if let result = response.result.value as? Dictionary<String,Any> {
                self.indicator.stopAnimating()
                let jsonResponse     = JSON(result)
                let jsonWeather      = jsonResponse["weather"].array![0]
                let jsontemp         = jsonResponse["main"]
                let jsonWind         = jsonResponse["wind"]
                let jsonRain         = jsonResponse["rain"]

                //1.ამინდის ლოგო
                self.conditionImage.image = UIImage.init(named: jsonWeather["icon"].stringValue)
                //2.ადგილი
                let city = jsonResponse["name"].stringValue
                SettingsManager.shared.cityName = city
                let sys = jsonResponse["sys"]
                let counrtyCode = sys["country"].stringValue
                SettingsManager.shared.countryCode = counrtyCode
                self.currentLocation.text = "\(city), \(counrtyCode)"
                
                //3.ტემპერატურა
                self.temperatureLbl.text = "\(Int(Double(jsontemp["temp"].stringValue) ?? 0))" + "º |"
                
                //4.კონდიცია
                self.dayDescriptionLbl.text = jsonWeather["main"].stringValue
                
                //5.ნალექი
                let precipitation = jsonRain["1h"].stringValue
                if precipitation.count > 0 {
                    self.precipitationLbl.text = "\(precipitation)mm/h"
                }else{
                    self.precipitationLbl.text = "-"
                }
 
                //6.ტენიანობა
                let humidity = jsontemp["humidity"].stringValue ?? ""
                self.humidityLbl.text = "\(humidity)"

                //7.hpa
                let pressure = jsontemp["pressure"].stringValue
                self.hpaLbl.text = "\(pressure) hPa"
                
                //8.ქარის სიჩქარე
                let speed = jsonWind["speed"].stringValue
                self.windSpeedLbl.text = "\(speed) km/h"
                
                //9. საიდან არის ქარი
                let degrees = Double(jsonWind["deg"].stringValue)
                if degrees != nil {
                    let polus = degrees!.getDirectionNameByDegrees()
                    self.windDirectionLbl.text = polus
                }else{
                    self.windDirectionLbl.text = "-"

                }
            }
        }
    }
    
    @IBOutlet weak var ComponentsMainBtnYPosition: NSLayoutConstraint!
    //MARK: For Transitions
    func changeToPortrait(){
        print("Portrait")
        ComponentsMainBtnYPosition.constant = -25
        topViewTopConstraint.constant = scrHeight/6
        secondComponentHorizontalConstraint.constant = 50
        fourthComponentHorizontalConstraint.constant = 50
        shareBtnBottomConstraint.constant = scrHeight/6
    }
    
    func changeToLandscape(){
        print("Landscape")
        ComponentsMainBtnYPosition.constant = 0
        topViewTopConstraint.constant = 20
        secondComponentHorizontalConstraint.constant = 0
        fourthComponentHorizontalConstraint.constant = 0
        shareBtnBottomConstraint.constant = 10
    }

    //MARK: Design
    func loadDesign(){
        conditionImage.layer.cornerRadius = conditionImage.frame.size.height/2
        addColorFullViewDottes()
        if UIApplication.shared.statusBarOrientation.isLandscape {
            changeToLandscape()
        } else {
            changeToPortrait()
        }
    }
    
//    CAShapeLayer.strokeColor - ზე ავტომატურად არ იმუშავა userInterfaceStyle -ის ცვლილებამ და ამიტომ
    func applyDarkOrLightMode(){
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                //Dark
                todayShapeLayer.strokeColor = UIColor.black.cgColor
            }
            else {
                //Light
                todayShapeLayer.strokeColor = UIColor.white.cgColor
            }
        }
    }
    
    func addColorFullViewDottes() {
        todayShapeLayer.strokeColor = UIColor(named: "backGroundColor")?.cgColor
        todayShapeLayer.lineWidth = 8
        todayShapeLayer.lineDashPattern = [3, 5] // პირველი არის ხაზის სიგრძე და მეორე არის გამოტოვების სიგრძე
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: -1), CGPoint(x: scrHeight+100, y: -1)])//scrHeight იმიტომ რომ  მარტივად გადამეწყვიტა მთლიანი ეკრანიშ შემტხვევაში +100 ითვალისწინებს ნოჩიანებს
        todayShapeLayer.path = path
        topColourfullView.layer.addSublayer(todayShapeLayer)
    }
        
    //MARK: - IBActions
    @IBAction func shareCurrentWeater(_ sender: Any) {
        if SettingsManager.shared.userCoordinate != nil{
            let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
            let text =      ("\(temperatureLbl.text ?? "") \(dayDescriptionLbl.text ?? ""),  \(currentLocation.text ?? "") ") + "by \(appName)"
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.message]

            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
