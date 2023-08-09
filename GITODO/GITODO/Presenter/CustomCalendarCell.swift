//
//  CustomCalendarCell.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/09.
//

import UIKit
import FSCalendar

final class CustomCalendarCell: FSCalendarCell {
    
    static let identifier: String = "CustomCalendarCell"
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}
