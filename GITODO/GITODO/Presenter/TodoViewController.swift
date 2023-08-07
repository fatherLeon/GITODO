//
//  ViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/04.
//

import UIKit
import FSCalendar
import Lottie

final class TodoViewController: UIViewController {
    
    private let today = Date()
    private var currentPage: Date?
    
    private let calendarHeaderStackView: UIStackView = {
        let headerStack = UIStackView()
        
        headerStack.axis = .horizontal
        headerStack.distribution = .fill
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        return headerStack
    }()
    private let calendarHeaderLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "2023-08"
        
        return label
    }()
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        
        calendar.headerHeight = 0
        calendar.scope = .week
        calendar.locale = Locale.current
        calendar.appearance.selectionColor = .red
        calendar.appearance.todayColor = .blue
        calendar.appearance.todaySelectionColor = .blue
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        return calendar
    }()
    private let leftArrowButton: AnimatedButton = {
        let btn = AnimatedButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.animationSpeed = 5
        btn.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        return btn
    }()
    private let rightArrowButton: AnimatedButton = {
        let btn = AnimatedButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.animationSpeed = 5
        btn.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        leftArrowButton.addTarget(self, action: #selector(movePrevWeek), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(moveNextWeek), for: .touchUpInside)
    }
    
    @objc func moveNextWeek() {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents.weekOfMonth = 1
        currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        
        guard let page = currentPage else { return }
        
        calendarView.setCurrentPage(page, animated: true)
    }
    
    @objc func movePrevWeek() {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents.weekOfMonth = -1
        currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        
        guard let page = currentPage else { return }
        calendarView.setCurrentPage(page, animated: true)
    }
}

// MARK: UI
extension TodoViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureNavigationHeaderView()
        configureCalendarHeaderView()
        configureCalendarView()
    }
    
    private func configureNavigationHeaderView() {
        self.navigationItem.title = "GITODO"
    }
    
    private func configureCalendarHeaderView() {
        guard let animation = LottieAnimationView(asset: "arrow").animation else { return }
        
        calendarHeaderStackView.addArrangedSubview(calendarHeaderLabel)
        calendarHeaderStackView.addArrangedSubview(leftArrowButton)
        calendarHeaderStackView.addArrangedSubview(rightArrowButton)
        
        leftArrowButton.animation = animation
        rightArrowButton.animation = animation
        
        view.addSubview(calendarHeaderStackView)
        
        NSLayoutConstraint.activate([
            leftArrowButton.widthAnchor.constraint(equalTo: calendarHeaderStackView.widthAnchor, multiplier: 0.1),
            leftArrowButton.heightAnchor.constraint(equalTo: leftArrowButton.heightAnchor),
            rightArrowButton.widthAnchor.constraint(equalTo: calendarHeaderStackView.widthAnchor, multiplier: 0.1),
            rightArrowButton.heightAnchor.constraint(equalTo: rightArrowButton.heightAnchor),
            
            calendarHeaderStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarHeaderStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            calendarHeaderStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarHeaderStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func configureCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarHeaderStackView.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: FSCalendar delegate datasource
extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarHeaderLabel.text = Date.toString(calendar.currentPage)
    }
}
