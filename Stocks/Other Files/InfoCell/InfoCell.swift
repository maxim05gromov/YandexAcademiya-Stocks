//
//  InfoCell.swift
//  Stocks
//
//  Created by Максим on 07.03.2021.
//
//  Модель строки TableView из InfoVC
import UIKit
class infoCell: UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Data: UILabel!
}
