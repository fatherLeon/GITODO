//
//  ThemeViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/28.
//

import UIKit

final class ThemeViewController: UIViewController {
    private enum ColorSet: Int, CaseIterable {
        case green
        case sky
        case red
        
        var set: [UIColor?] {
            switch self {
            case .green:
                return CustomColor.GreenColorSet
            case .red:
                return CustomColor.RedColorSet
            case .sky:
                return CustomColor.SkyColorSet
            }
        }
    }
    
    private var colorSet: [UIColor?] = CustomColor.CommitColorSet
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: TableView Delegate, Datasource
extension ThemeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorSet.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.identifier) as? ThemeCell,
              let colorSet = ColorSet(rawValue: indexPath.row)?.set,
              let firstColor = colorSet[safe: 0] as? UIColor,
              let secondColor = colorSet[safe: 1] as? UIColor,
              let thirdColor = colorSet[safe: 2] as? UIColor else { return UITableViewCell() }
        
        if self.colorSet == colorSet {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.updateColorSet(firstColor, secondColor, thirdColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let colorSet = ColorSet(rawValue: indexPath.row)?.set else { return }
        
        self.colorSet = colorSet
        CustomColor.CommitColorSet = colorSet
        
        let userdefault = UserDefaultManager()
        let colorKey = CustomColor.getColorKey(by: self.colorSet)
        
        userdefault.saveColorKey(colorKey, UserDefaultManager.themeKey)
        
        self.tableView.reloadData()
    }
}

// MARK: Configure UI Components
extension ThemeViewController {
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(ThemeCell.self, forCellReuseIdentifier: ThemeCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
