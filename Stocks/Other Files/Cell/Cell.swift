//
//  Cell.swift
//  Stocks
//
//  Created by Максим on 06.03.2021.
//
//  Модель строки TableView из StocksVC
import UIKit
class Cell: UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var StockImage: UIImageView!
    @IBOutlet weak var StockSymbol: UILabel!
    @IBOutlet weak var StockName: UILabel!
    @IBOutlet weak var StockCost: UILabel!
    @IBOutlet weak var StockChange: UILabel!
}
