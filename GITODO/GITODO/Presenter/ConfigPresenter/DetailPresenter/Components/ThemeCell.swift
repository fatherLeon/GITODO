//
//  ThemeCell.swift
//  GITODO
//
//  Created by 강민수 on 2023/09/01.
//

import UIKit

final class ThemeCell: UITableViewCell {
    
    static let identifier: String = "ThemeCell"
    
    private let firstColorView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let secondColorView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let thirdColorView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColorSet(_ firstColor: UIColor, _ secondColor: UIColor, _ thirdColor: UIColor) {
        self.firstColorView.backgroundColor = firstColor
        self.secondColorView.backgroundColor = secondColor
        self.thirdColorView.backgroundColor = thirdColor
    }
}

// MARK: Configure UI Components
extension ThemeCell {
    private func configureView() {
        let stackView = UIStackView(arrangedSubviews: [firstColorView, secondColorView, thirdColorView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
