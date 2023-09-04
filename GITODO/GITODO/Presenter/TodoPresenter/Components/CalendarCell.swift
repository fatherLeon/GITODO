//
//  CalendarCell.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/25.
//

import UIKit
import FSCalendar

private enum SelectionType: Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

final class CalendarCell: FSCalendarCell {
    
    static let identifier: String = "CalendarCell"
    
    weak var rectImageView: UIImageView?
    weak var selectionLayer: CAShapeLayer?
    
    private var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        let rectImage = UIImage(systemName: "rectangle")
        let rectImageView = UIImageView(image: rectImage)
        
        rectImageView.layer.cornerRadius = 10
        rectImageView.layer.borderWidth = self.contentView.bounds.height / 10
        rectImageView.layer.borderColor = UIColor.systemBackground.cgColor
        
        self.contentView.insertSubview(rectImageView, at: 0)
        self.rectImageView = rectImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.black.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.systemBackground
        self.backgroundView = view
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.rectImageView?.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer?.frame = self.contentView.bounds
        
        guard let selectionLayer = self.selectionLayer else { return }
        
        if selectionType == .single {
            let diameter: CGFloat = min(selectionLayer.frame.height, selectionLayer.frame.width)
            self.selectionLayer?.path = UIBezierPath(ovalIn: CGRect(x: contentView.frame.width / 2 - diameter / 2, y: contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
        
        if isSelected {
            self.rectImageView?.backgroundColor = .systemPurple
            self.rectImageView?.tintColor = .systemPurple
        }
        
        if dateIsToday {
            self.rectImageView?.backgroundColor = .systemRed
            self.rectImageView?.tintColor = .systemRed
            self.titleLabel.font = .boldSystemFont(ofSize: 16)
        }
    }
    
    func updateUI(_ rectImageBackgroundColor: UIColor) {
        rectImageView?.backgroundColor = rectImageBackgroundColor
        rectImageView?.tintColor = rectImageBackgroundColor
    }
}
