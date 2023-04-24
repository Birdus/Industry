//
//  StatisticUserViewController.swift
//  Industry
//
//  Created by  Даниил on 24.04.2023.
//

import UIKit

class StatisticUserViewController: UIViewController {

    //    private lazy var brChMonenyForMouth: BarChartView = {
    //        let barChart: BarChartView = BarChartView()
    //        barChart.translatesAutoresizingMaskIntoConstraints = false
    //        barChart.xAxis.labelPosition = .bottom // позиция подписей оси X
    //        barChart.xAxis.labelTextColor = .black // цвет подписей оси X
    //        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"])
    //
    //        barChart.chartDescription.text = "Зарплата по месяцам".localized
    //        return barChart
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    private func configureUI() {
        //        var entries = [BarChartDataEntry]()
        //        for x in 1...12 {
        //            entries.append(BarChartDataEntry(x: Double(x), y: Double(60 * x)))
        //        }
                
        //        let dataSet = BarChartDataSet(entries: entries, label: "₽")
                
        //        brChMonenyForMouth.data = BarChartData(dataSet: dataSet)
    }

}
