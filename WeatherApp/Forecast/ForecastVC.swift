//
//  ForecastVC.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/19/20.

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

struct Weather {
    let description     : String
    let temperature     : String
    let time            : String
    let dayOfWeek       : String
    let icon            : String
}

class ForecastVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var daysTableView                        : UITableView!
    @IBOutlet weak var topColourfullView                    : UIView!
    @IBOutlet weak var indicator                            : UIActivityIndicatorView!
    
    //MARK: - Variables
    var forecastShapeLayer                                  = CAShapeLayer()
    var allweather                                          = Array<Weather>()
    var grouppedWeather                                     = Array<Array<Weather>>()

    //MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addColorFullViewDottes()
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
    //MARK: - My Functions
    //MARK: Notifications
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(getDataWithCoordinates(Notification: )), name: NSNotification.Name(rawValue: weHaveCoordinateKey), object: nil)
    }
    
    @objc func getDataWithCoordinates(Notification: Notification){
        guard let coord = Notification.userInfo!["Cooordinate"] as! CLLocationCoordinate2D? else { return }
        getData(coordinate: coord)
    }
    
    //MARK: For Location
    func getData(coordinate: CLLocationCoordinate2D){
        indicator.startAnimating()
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast?q=\(SettingsManager.shared.cityName)&appid=\(SettingsManager.shared.apiKey)&units=metric", method: .get, parameters: [:], encoding: URLEncoding.httpBody,headers: nil).responseJSON { (response) in
            self.indicator.stopAnimating()
            if let result = response.result.value as? Dictionary<String,Any> {
                self.indicator.stopAnimating()
                let jsonResponse = JSON(result)
                self.navigationItem.title = "\(jsonResponse["city"]["name"].stringValue), \(jsonResponse["city"]["country"].stringValue)"
                if let weatherListArray = jsonResponse["list"].array {
                    if weatherListArray.count > 0 {
                        self.allweather = []
                        for item in weatherListArray{
                            let mainDataJson         = item["main"]
                            let temp                 = mainDataJson["temp"].stringValue
                            let weatherDataJson      = item["weather"]
                            let weatherDescription   = weatherDataJson[0]["description"].stringValue
                            let weatherIcon          = weatherDataJson[0]["icon"].stringValue
                            let date                 = item["dt_txt"].stringValue
                            let dayOfWeek            = self.getDayNameBy(stringDate: date)
                            let weather              = Weather(description: weatherDescription, temperature: temp, time: date, dayOfWeek: dayOfWeek, icon: weatherIcon)
                            self.allweather.append(weather)
                        }
                        if self.allweather.count > 0{
                            self.grouppedWeather = self.allweather.group(by: {$0.dayOfWeek})
                            self.daysTableView.reloadData()
                        }
                    }
                }
            }else{
                
            }
        }
    }

    func getDayNameBy(stringDate: String) -> String{
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date)
    }

    //MARK: Design
    //    CAShapeLayer.strokeColor - ზე ავტომატურად არ იმუშავა userInterfaceStyle -ის ცვლილებამ და ამიტომ
    func applyDarkOrLightMode(){
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                //Dark
                forecastShapeLayer.strokeColor = UIColor.black.cgColor
            }
            else {
                //Light
                forecastShapeLayer.strokeColor = UIColor.white.cgColor
            }
        }
    }
    
    func addColorFullViewDottes() {
        forecastShapeLayer.strokeColor = UIColor(named: "backGroundColor")?.cgColor
        forecastShapeLayer.lineWidth = 8
        forecastShapeLayer.lineDashPattern = [3, 5] // პირველი არის ხაზის სიგრძე და მეორე არის გამოტოვების სიგრძე
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: -1), CGPoint(x: scrHeight+100, y: -1)])//scrHeight იმიტომ რომ  მარტივად გადამეწყვიტა მთლიანი ეკრანიშ შემტხვევაში +100 ითვალისწინებს ნოჩიანებს
        forecastShapeLayer.path = path
        topColourfullView.layer.addSublayer(forecastShapeLayer)
    }
}
