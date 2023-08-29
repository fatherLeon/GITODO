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
    private var isFetchedRepo = true
    
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
    
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private let searchStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func searchRepository(text: String, perPage: Int = 30, errorMessage: String?) {
        /*
         Input - text : 유저 닉네임, perPage: 페이지 당 받아올 데이터, page: 페이지 넘버
         output - Void
         기능 - 레포지토리 검색하여 `self.repos`에 추가 및 테이블 뷰 reload
         */
        
        gitManager.searchRepos(by: text, perPage: perPage, page: self.page) { [weak self] repos in
            if repos.isEmpty {
                DispatchQueue.main.async {
                    self?.showAlert(title: "레포지토리가 존재하지 않습니다.", message: errorMessage)
                    self?.stopIndicatorView()
                    self?.isFetchedRepo = false
                }
                return
            }
            
            self?.repos += repos
            self?.page += 1
            DispatchQueue.main.async {
                self?.view.endEditing(true)
                self?.stopIndicatorView()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func startIndicatorView() {
        /*
         기능 - IndicatorView 보여주기, 애니메이션 시작
         */
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    private func stopIndicatorView() {
        /*
         기능 - IndicatorView 숨기기, 애니메이션 정지
         */
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    @objc private func clickedSearchButton() {
        guard let text = textField.text else { return }
        
        startIndicatorView()
        searchRepository(text: text, errorMessage: "닉네임을 확인해주세요.")
    }
    
    @objc private func didChangeTextInTextField() {
        self.page = 1
        self.isFetchedRepo = true
        self.repos = []
        
        tableView.reloadData()
    }
}

// MARK: UITableView Delegate, DataSource
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.repos.count - 1 && isFetchedRepo {
            guard let text = textField.text else { return }
            searchRepository(text: text, errorMessage: "더 이상의 레포지토리가 존재하지 않습니다.")
        }
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
        configureIndicatorView()
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(didChangeTextInTextField), for: .editingChanged)
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
    
    private func configureIndicatorView() {
        self.view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

