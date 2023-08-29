//
//  RepoCell.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/29.
//

import UIKit

class RepoCell: UITableViewCell {
    
    static let identifier = "RepoCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 3
        
        return label
    }()
    
    private let createdLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let updatedLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, createdLabel, updatedLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        descLabel.text = ""
        createdLabel.text = ""
        updatedLabel.text = ""
    }
    
    func updateCell(_ repo: GitRepository) {
        titleLabel.text = repo.name
        descLabel.text = repo.description
        
        guard let createdAt = Date.toISO8601Date(repo.createdAt),
              let updatedAt = Date.toISO8601Date(repo.updatedAt) else { return }
        
        createdLabel.text = "Created on \(Date.toString(createdAt))"
        updatedLabel.text = "Updated on \(Date.toString(updatedAt))"
    }
}

// MARK: Configure UI Components
extension RepoCell {
    private func configureView() {
        configureContentStackView()
    }
    
    private func configureContentStackView() {
        self.contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
