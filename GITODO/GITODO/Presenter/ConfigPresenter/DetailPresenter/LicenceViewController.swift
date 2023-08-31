//
//  LicenceViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/28.
//

import UIKit

final class LicenceViewController: UIViewController {
    
    private let licence: [String] = ["FSCalendar", "Lottie", "RxSwift", "LottieFiles"]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: TableView Delegate, DataSource
extension LicenceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licence.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier) as? TodoCell,
              let title = licence[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.updateCell(title, false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "라이센스"
    }
}

// MARK: Configure UI Components
extension LicenceViewController {
    private func configureUI() {
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
