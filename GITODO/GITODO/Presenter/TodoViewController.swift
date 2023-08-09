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
    private var calendarHeightAnchor: NSLayoutConstraint?
    
    private let calendarHeaderStackView: UIStackView = {
        let headerStack = UIStackView()
        
        headerStack.axis = .horizontal
        headerStack.distribution = .fill
        headerStack.alignment = .fill
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
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        
        calendar.headerHeight = 0
        calendar.scope = .week
        calendar.scrollDirection = .vertical
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
    private let calendarButton: AnimatedButton = {
        let btn = AnimatedButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.animationSpeed = 3.0
        
        return btn
    }()
    private let addAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "add")
        
        view.animationSpeed = 2.0
        view.loopMode = .playOnce
        view.backgroundBehavior = .pauseAndRestore
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        leftArrowButton.addTarget(self, action: #selector(movePrevWeek), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(moveNextWeek), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(moveTodayWeek), for: .touchUpInside)
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
    
    @objc func moveTodayWeek() {
        calendarView.setCurrentPage(today, animated: true)
    }
    
    @objc func clickedAddButton() {
        addAnimationView.play()
    }
}

// MARK: UI
extension TodoViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureNavigationHeaderView()
        configureCalendarHeaderView()
        configureCalendarView()
        configureTableView()
    }
    
    private func configureNavigationHeaderView() {
        self.navigationItem.title = "GITODO"
        self.addAnimationView.frame.size = CGSize(width: 30, height: 30)
        self.addAnimationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedAddButton)))
        let barbutton = UIBarButtonItem(customView: addAnimationView)
        
        barbutton.target = self
        barbutton.action = #selector(clickedAddButton)
        
        self.navigationItem.rightBarButtonItem = barbutton
    }
    
    private func configureCalendarHeaderView() {
        calendarHeaderStackView.addArrangedSubview(calendarHeaderLabel)
        calendarHeaderStackView.addArrangedSubview(calendarButton)
        calendarHeaderStackView.addArrangedSubview(leftArrowButton)
        calendarHeaderStackView.addArrangedSubview(rightArrowButton)
        
        guard let arrowAnimation = LottieAnimation.named("arrow"),
              let calendarAnimation = LottieAnimation.named("calendar") else { return }
        
        leftArrowButton.animation = arrowAnimation
        rightArrowButton.animation = arrowAnimation
        calendarButton.animation = calendarAnimation
        
        view.addSubview(calendarHeaderStackView)
        
        NSLayoutConstraint.activate([
            leftArrowButton.widthAnchor.constraint(equalTo: calendarHeaderStackView.widthAnchor, multiplier: 0.1),
            leftArrowButton.heightAnchor.constraint(equalTo: leftArrowButton.heightAnchor),
            rightArrowButton.widthAnchor.constraint(equalTo: calendarHeaderStackView.widthAnchor, multiplier: 0.1),
            rightArrowButton.heightAnchor.constraint(equalTo: rightArrowButton.heightAnchor),
            calendarButton.widthAnchor.constraint(equalTo: calendarHeaderStackView.widthAnchor, multiplier: 0.2),
            calendarButton.heightAnchor.constraint(equalTo: calendarButton.heightAnchor),
            
            calendarHeaderStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarHeaderStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            calendarHeaderStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarHeaderStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func configureCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(CustomCalendarCell.self, forCellReuseIdentifier: CustomCalendarCell.identifier)
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarHeaderStackView.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        calendarHeightAnchor = calendarView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        calendarHeightAnchor?.isActive = true
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: TableView delegate datasource
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: FSCalendar delegate datasource
extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        return calendar.dequeueReusableCell(withIdentifier: CustomCalendarCell.identifier, for: date, at: .current)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarHeaderLabel.text = Date.toString(calendar.currentPage)
        
        if currentPage ?? Date() >= calendar.currentPage {
            leftArrowButton.animationView.play()
        } else {
            rightArrowButton.animationView.play()
        }
        currentPage = calendar.currentPage
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.red]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [.red]
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightAnchor?.constant = bounds.height
    }
}
