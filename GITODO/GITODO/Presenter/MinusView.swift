//
//  MinusView.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/21.
//

import UIKit

final class MinusView: UIView {
    
    private let minusImageView: UIImageView = {
        let image = UIImage(systemName: "minus")
        let view = UIImageView(image: image)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .darkGray
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI
extension MinusView {
    private func configureUI() {
        self.addSubview(minusImageView)
        
        NSLayoutConstraint.activate([
            minusImageView.topAnchor.constraint(equalTo: self.topAnchor),
            minusImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            minusImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
