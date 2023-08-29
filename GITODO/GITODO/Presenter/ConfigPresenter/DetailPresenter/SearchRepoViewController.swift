//
//  SearchRepoViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/28.
//

import UIKit

final class SearchRepoViewController: UIViewController {
        
    private let gitManager = GitManager()
    private var repos: GitRepositories = []
    private var page: Int = 1
    
    private let textField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "유저 닉네임을 입력해주세요."
        textField.font = .boldSystemFont(ofSize: 17)
        
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("검색", for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let searchStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func searchRepository(text: String, perPage: Int = 30, page: Int = 1) {
        /*
         Input - text : 유저 닉네임, perPage: 페이지 당 받아올 데이터, page: 페이지 넘버
         output - Void
         기능 - 레포지토리 검색하여 `self.repos`에 추가 및 테이블 뷰 reload
         */
        
        gitManager.searchRepos(by: text, perPage: perPage, page: page) { [weak self] repos in
            if repos.isEmpty {
                self?.showAlert(title: "레포지토리가 존재하지 않습니다.", message: "닉네임을 확인해주세요.")
                return
            }
            
            self?.repos += repos
            self?.page += 1
            DispatchQueue.main.async {
                self?.view.endEditing(true)
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func clickedSearchButton() {
        guard let text = textField.text else { return }
        
        searchRepository(text: text, page: page)
    }
}

extension SearchRepoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier) as? RepoCell else {
            return UITableViewCell()
        }
        
        let repo = repos[indexPath.row]
        cell.updateCell(repo)
        
        return cell
    }
}

// MARK: Configure UI Components
extension SearchRepoViewController {
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        configureTextField()
        configureSearchButton()
        configureSearchStackView()
        configureTableView()
    }
    
    private func configureTextField() {
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.25
        textField.layer.borderColor = UIColor.gray.cgColor
        
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func configureSearchButton() {
        searchButton.layer.cornerRadius = 10
        searchButton.addTarget(self, action: #selector(clickedSearchButton), for: .touchUpInside)
    }
    
    private func configureSearchStackView() {
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        
        searchStackView.addArrangedSubview(textField)
        searchStackView.addArrangedSubview(searchButton)
        searchStackView.spacing = 10
        
        self.view.addSubview(searchStackView)
        
        NSLayoutConstraint.activate([
            searchStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            searchStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            textField.widthAnchor.constraint(equalTo: searchStackView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func configureTableView() {
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.identifier)
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

