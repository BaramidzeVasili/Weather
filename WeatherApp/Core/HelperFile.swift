//
//  HelperFile.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/19/20.
//

import Foundation
import UIKit
/*
  markShortCuts
 //MARK: - IBOutlets
 //MARK: - Variables
 //MARK: - Overriden Functions
 //MARK: - My Functions
 */


var scrWidth                                            = UIScreen.main.bounds.size.width
var scrHeight                                           = UIScreen.main.bounds.size.height

//MARK: - Extensions

//MARK: UIColor
extension UIColor {
    func hexStringToUIColor (hex:String) -> UIColor {
        let cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK: Array
extension Array {
    func group<U: Hashable>(by key: (Element) -> U) -> [[Element]] {
        var indexKeys = [U : Int]()
        var grouped = [[Element]]()
        for element in self {
            let key = key(element)
            if let ind = indexKeys[key] {
                grouped[ind].append(element)
            }
            else {
                grouped.append([element])
                indexKeys[key] = grouped.count - 1
            }
        }
        return grouped
    }
}
//MARK: UIColor
extension UIView {
    func drawDottedLine(color:CGColor!) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 8
        shapeLayer.lineDashPattern = [3, 5] // პირველი არის ხაზის სიგრძე და მეორე არის გამოტოვების სიგრძე
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: -1), CGPoint(x: scrHeight+100, y: -1)])//scrHeight იმიტომ რომ  მარტივად გადამეწყვიტა მთლიანი ეკრანიშ შემტხვევაში +100 ითვალისწინებს ნოჩიანებს
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}


//MARK: UIColor
extension Double {
    func getDirectionNameByDegrees()->String?{
        var direc = ""
        if 348.75 <= self, self <= 360  { direc =  "N" }
        else if 0 <= self,self <= 11.25 { direc = "N" }
        else if 11.25 < self, self <= 33.75 { direc = "NNE" }
        else if 33.75 < self, self <= 56.25 { direc = "NE" }
        else if 56.25 < self, self <= 78.75 { direc = "ENE" }
        else if 78.75 < self, self <= 101.25 { direc = "E" }
        else if 101.25 < self, self <= 123.75 { direc = "ESE" }
        else if 123.75 < self, self <= 146.25 { direc = "SE" }
        else if 146.25 < self, self <= 168.75 { direc = "SSE" }
        else if 168.75 < self, self <= 191.25 { direc = "S" }
        else if 191.25 < self, self <= 213.75 { direc = "SSW" }
        else if 213.75 < self, self <= 236.25 { direc = "SW" }
        else if 236.25 < self, self <= 258.75 { direc = "WSW" }
        else if 258.75 < self, self <= 281.25 { direc = "W" }
        else if 281.25 < self, self <= 303.75 { direc = "WNW" }
        else if 303.75 < self, self <= 326.25 { direc = "NW" }
        else if 326.25 < self, self < 348.75 { direc = "NNW" }
        return direc
    }
}



