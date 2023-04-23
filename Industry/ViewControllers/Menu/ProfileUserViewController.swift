//
//  ProfileUserViewController.swift
//  Industry
//
//  Created by Даниил on 14.03.2023.
//
import Charts
import UIKit

class ProfileUserViewController: UIViewController {
    
    lazy private var collViewDescribeUser: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/2)
        layout.sectionInsetReference = .fromSafeArea
        layout.itemSize.width = view.bounds.width
        layout.itemSize.height = view.bounds.height/2
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height/2)
        layout.sectionInsetReference = .fromSafeArea
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/2)
        layout.sectionInsetReference = .fromSafeArea
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserDescriptionCollViewCell.self, forCellWithReuseIdentifier: UserDescriptionCollViewCell.indificatorCell)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var tblCountCompliteTask: UITableView = {
        let tbl = UITableView()
        tbl.register(UserCountTaskTblViewCell.self, forCellReuseIdentifier: UserCountTaskTblViewCell.indificatorCell)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.separatorStyle = .none
        tbl.separatorColor = .white
        tbl.isScrollEnabled = false
        return tbl
    }()
    
    private lazy var brChMonenyForMouth: BarChartView = {
        let barChart: BarChartView = BarChartView()
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.xAxis.labelPosition = .bottom // позиция подписей оси X
        barChart.xAxis.labelTextColor = .black // цвет подписей оси X
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"])
        
        barChart.chartDescription.text = "Зарплата по месяцам".localized
        return barChart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collViewDescribeUser)
        view.addSubview(tblCountCompliteTask)
        view.addSubview(brChMonenyForMouth)
        self.navigationController?.isNavigationBarHidden = true
        
        var entries = [BarChartDataEntry]()
        for x in 1...12 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(60 * x)))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "₽")
        
        brChMonenyForMouth.data = BarChartData(dataSet: dataSet)
    
        let tblRowHeight = ((UIScreen.main.bounds.size.height / 2 + tblCountCompliteTask.contentOffset.y) / 2) / 2
        
        NSLayoutConstraint.activate([
            collViewDescribeUser.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collViewDescribeUser.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collViewDescribeUser.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collViewDescribeUser.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.35),

            tblCountCompliteTask.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tblCountCompliteTask.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tblCountCompliteTask.topAnchor.constraint(equalTo: collViewDescribeUser.bottomAnchor, constant: 5),
            tblCountCompliteTask.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            brChMonenyForMouth.topAnchor.constraint(equalTo: tblCountCompliteTask.bottomAnchor, constant: -40),
            brChMonenyForMouth.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            brChMonenyForMouth.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            brChMonenyForMouth.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
        ])

        tblCountCompliteTask.rowHeight = tblRowHeight
    }
}

extension ProfileUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .gray
        return view
    }
}

extension ProfileUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCountTaskTblViewCell.indificatorCell, for: indexPath) as? UserCountTaskTblViewCell else {
                fatalError("Unable to dequeue cell.")
            }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.fiillTable(10, 20)
        return cell
    }
    
    
}

extension ProfileUserViewController: UICollectionViewDelegate {
    
}

extension ProfileUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collViewDescribeUser.dequeueReusableCell(withReuseIdentifier: UserDescriptionCollViewCell.indificatorCell, for: indexPath) as! UserDescriptionCollViewCell
        
        cell.backgroundColor = UIColor(ciColor: CIColor.init(red: 0/255, green: 130/255, blue: 255/255, alpha: 0.8))
        cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        cell.layer.cornerRadius = 10
        cell.fillTable("Гетманцев Даниил Олегович", "Админ", "IT", 45523)

        return cell
    }
    
}
