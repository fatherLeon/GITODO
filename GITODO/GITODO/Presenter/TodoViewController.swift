//
//  ViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/04.
//

import UIKit
import FSCalendar

final class TodoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: UI
extension TodoViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureCalendar()
    }
    
    private func configureCalendar() {
        let calendar = FSCalendar(frame: .zero)
        
        calendar.headerHeight = 0
        calendar.scope = .week
        calendar.locale = Locale.current
        calendar.appearance.selectionColor = .red
        calendar.appearance.todayColor = .blue
        calendar.appearance.todaySelectionColor = .blue
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: FSCalendar delegate datasource
extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}
