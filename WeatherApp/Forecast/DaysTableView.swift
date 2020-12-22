//
//  DaysTableView.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/20/20.
//

import Foundation
import UIKit

extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    //MARK: - sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return grouppedWeather.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grouppedWeather[section].count
    }
    
    //MARK: - cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaysTableviewCell", for: indexPath) as! DaysTableviewCell
        let currentWeather = grouppedWeather[indexPath.section][indexPath.row]
        cell.loadDesign()
        cell.fillCellData(weather: currentWeather)
        //თუ ბოლოა, რადგან ჰედერი გვაქვს ორხაზიანი
        if indexPath.row == grouppedWeather[indexPath.section].count-1{
            cell.bottomSeparatorView.isHidden = true
        }else{
            cell.bottomSeparatorView.isHidden = false
        }
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
    }
    
    //MARK: - Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("DaysSectionHeader", owner: nil, options: nil)?.first as? DaysSectionHeader
        let currentWeather = grouppedWeather[section][0]
        if section == 0 {
            headerView?.headerTitle.text = "TODAY"
        }else{
            headerView?.headerTitle.text = "\(currentWeather.dayOfWeek)"
        }
        return headerView
    }
}
