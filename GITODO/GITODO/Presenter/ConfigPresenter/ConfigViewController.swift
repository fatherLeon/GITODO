//
//  ConfigViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import UIKit

final class ConfigViewController: UIViewController {
    private enum ConfigContent: Int, CaseIterable {
        case githubRepository
        case theme
        case licence
        
        var title: String {
            switch self {
            case .githubRepository:
                return "깃허브 레포지토리"
            case .theme:
                return "테마"
            case .licence:
                return "라이센스"
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .githubRepository:
                return SearchRepoViewController()
            case .theme:
                return ThemeViewController()
            case .licence:
                return LicenceViewController()
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

// MARK: TableView Delegate, Datasource
extension ConfigViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfigContent.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell,
              let title = ConfigContent(rawValue: indexPath.row)?.title else {
            return UITableViewCell()
        }
        
        cell.updateCell(title, false)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let viewController = ConfigContent(rawValue: indexPath.row)?.viewController else { return }
        
        self.present(viewController, animated: true)
    }
}

// MARK: configure UI Components
extension ConfigViewController {
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        configureNavigationView()
        configureTableView()
    }
    
    private func configureNavigationView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "설정"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
