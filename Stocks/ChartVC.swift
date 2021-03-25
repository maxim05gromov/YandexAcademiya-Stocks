//
//  ChartVC.swift
//  Stocks
//
//  Created by Максим on 20.03.2021.
//
//  ViewController для отображения графика изменения цены акций. Здесь же происходит загрузка этих данных об акции
import UIKit
class chartVC: UIViewController, LineChartDelegate{
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        print("pressed")
    }
    
    var lineChart: LineChart!
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .white
        var views: [String: AnyObject] = [:]
        let data: [CGFloat] = [3, 4, -2, 11, 13, 15]
        let data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[chart(==200)]", options: [], metrics: nil, views: views))
    }
}
