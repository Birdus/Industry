//
//  StatisticUserViewController.swift
//  Industry
//
//  Created by  Даниил on 24.04.2023.
//
import Charts
import UIKit

class StatisticUserViewController: UIViewController {
    
    // MARK: - Private UI
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "✖️", style: .plain, target: self, action: #selector(btnBack_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2, weight: .bold),
        ], for: .normal)
        return btn
    }()
    
    private lazy var btnSeting: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Настройки".localized, style: .done, target: self, action: #selector(btnSeting_Click))
        return btn
    }()
    
    private lazy var brChStatic: BarChartView = {
        let barChart: BarChartView = BarChartView()
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelTextColor = .black
        barChart.xAxis.labelRotationAngle = 45
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false
        return barChart
    }()
    
    private lazy var pieChStatic: PieChartView = {
        let pieChart: PieChartView = PieChartView()
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.legend.enabled = true
        pieChart.legend.horizontalAlignment = .left
        pieChart.legend.verticalAlignment = .center
        pieChart.legend.orientation = .vertical
        pieChart.drawEntryLabelsEnabled = true
        return pieChart
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        showMenu()
    }
    
    // MARK: - Actions
    @objc
    private func btnBack_Click(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc
    private func btnSeting_Click(_ sender: UIButton) {
        showMenu()
    }
    
    // MARK: - Private Methods
    private func showMenu() {
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: "Продолжительность статистики".localized, message: nil, preferredStyle: .alert)
            
            let btnShowMoneyOfWeak: UIAlertAction = {
                let btn = UIAlertAction(title: "За неделю".localized,
                                        style: .default,
                                        handler: {(alert: UIAlertAction!) in
                    self.showStatistics(for: .week)
                })
                return btn
            }()
            
            let btnShowMoneyOfMouth: UIAlertAction = {
                let btn = UIAlertAction(title: "За месяц".localized,
                                        style: .default,
                                        handler: {(alert: UIAlertAction!) in
                    self.showStatistics(for: .month)
                })
                return btn
            }()
            
            let btnShowMoneyOfYear: UIAlertAction = {
                let btn = UIAlertAction(title: "За год".localized,
                                        style: .default,
                                        handler: {(alert: UIAlertAction!) in
                    self.showStatistics(for: .year)
                })
                return btn
            }()
            
            let btnCancel: UIAlertAction = {
                let btn = UIAlertAction(title: "Отмена".localized,
                                        style: .cancel,
                                        handler: {(alert: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                })
                return btn
            }()
            alControl.addAction(btnShowMoneyOfWeak)
            alControl.addAction(btnShowMoneyOfMouth)
            alControl.addAction(btnShowMoneyOfYear)
            alControl.addAction(btnCancel)
            return alControl
        }()
        present(alControl, animated: true, completion: nil)
    }
    
    private func showStatistics(for duration: Duration) {
        let formatter = IndexAxisValueFormatter(values: duration.description.map { "\($0)" })
        brChStatic.xAxis.valueFormatter = formatter
        
        var entriesPie = [PieChartDataEntry]()
        for x in 0..<duration.description.count {
            entriesPie.append(PieChartDataEntry(value: Double(60 * x), label: duration.description[x]))
        }
        
        var entries = [BarChartDataEntry]()
        for x in 0..<duration.description.count {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(60 * x)))
        }
        let dataSetBrCh = BarChartDataSet(entries: entries, label: "₽")
        brChStatic.data = BarChartData(dataSet: dataSetBrCh)
        let dataSetPieCh = PieChartDataSet(entries: entriesPie, label: "Затраченное время по часам".localized)
        dataSetPieCh.colors = ChartColorTemplates.vordiplom()
        dataSetPieCh.entryLabelColor = .clear
        dataSetPieCh.valueTextColor = .black
        pieChStatic.data = PieChartData(dataSet: dataSetPieCh)
        configureUI()
    }
    
    private func configureUI() {
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.rightBarButtonItem = btnSeting
        self.navigationController?.isNavigationBarHidden = false
        self.view.addSubview(brChStatic)
        self.view.addSubview(pieChStatic)
        NSLayoutConstraint.activate([
            brChStatic.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            brChStatic.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            brChStatic.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            brChStatic.topAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            pieChStatic.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            pieChStatic.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            pieChStatic.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pieChStatic.bottomAnchor.constraint(equalTo: brChStatic.topAnchor,constant: 5),
        ])
    }
}
