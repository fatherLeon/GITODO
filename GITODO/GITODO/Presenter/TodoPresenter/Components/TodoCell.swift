//
//  TodoCell.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/16.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    static let identifier = "TodoCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
    }
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension TodoCell {
    private func configureUI() {
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
}
