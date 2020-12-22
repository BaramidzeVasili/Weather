//
//  DaysTableviewCell.swift
//  WeatherApp
//
//  Created by Vasili Baramidze on 12/20/20.
//

import UIKit

class DaysTableviewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var cellImage            : UIImageView!
    @IBOutlet weak var time                 : UILabel!
    @IBOutlet weak var weatherDescription   : UILabel!
    @IBOutlet weak var temperatureLbl       : UILabel!
    @IBOutlet weak var bottomSeparatorView  : UIImageView!
    
    
    //MARK: - Variables
    let nightColor   = UIColor.init(named: "nightColor")?.cgColor
    let dayColor     = UIColor.init(named: "dayColor")?.cgColor

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - My Functions
    func loadDesign(){
        cellImage.layer.cornerRadius = cellImage.frame.size.width / 2
    }
    
    func fillCellData(weather:Weather){
        time.text = getHour(stringDate: weather.time)
//        cellImage.layer.backgroundColor = isAmDate(StringDate:weather.time) ? dayColor: nightColor
        cellImage.image = UIImage(named: weather.icon)
        weatherDescription.text = weather.description
        temperatureLbl.text = "\(Int(Double(weather.temperature)!)) ºC"
    }

    func getHour(stringDate: String) -> String{
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }
    
    func isAmDate(StringDate:String)->Bool{
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: StringDate)!
        df.dateFormat = "a"
        
        if df.string(from: date) == "AM"{
            return true
        } else{
            return false
        }
        
    }
    
}
