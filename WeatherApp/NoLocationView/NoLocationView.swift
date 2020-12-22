//
//  NoLocationView.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/20/20.
//

import UIKit



class NoLocationView: UIView {
    //MARK: IBOutlets
    @IBOutlet weak var allowLocationBtn: UIButton!
        
    //MARK: IBActions
    @IBAction func allowLocationAction(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            })
        }
    }
}
