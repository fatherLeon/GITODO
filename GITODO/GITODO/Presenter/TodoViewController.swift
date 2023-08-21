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
    private var selectedDate = Date()
    private var currentPage: Date?
    private var todos: [TodoObject] = []
    private let coredataManager = CoreDataManager.shared
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
        label.text = Date.toString(Date())
        
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
    private let minusView: MinusView = {
        let view = MinusView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        leftArrowButton.addTarget(self, action: #selector(clickedLeftArrowBtn), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(clickedRightArrowBtn), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(clickedCalendarBtn), for: .touchUpInside)
        
        changedTargetDate(today)
    }
    
    private func changedTargetDate(_ date: Date) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return }
        
        let targetId = "\(year)-\(month)-\(day)"
        
        do {
            guard let todos = try coredataManager.search(targetId, type: TodoObject.self) as? [TodoObject] else {
                self.todos = []
                return
            }
            
            self.todos = todos
            self.tableView.reloadData()
        } catch {
            print("Error - Search Error")
        }
    }
    
    @objc func clickedRightArrowBtn() {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        if calendarView.scope == .week {
            dateComponents.weekOfMonth = 1
            currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        } else {
            dateComponents.month = 1
            currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        }
        
        guard let page = currentPage else { return }
        calendarView.setCurrentPage(page, animated: true)
    }
    
    @objc func clickedLeftArrowBtn() {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        if calendarView.scope == .week {
            dateComponents.weekOfMonth = -1
            currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        } else {
            dateComponents.month = -1
            currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        }
        
        guard let page = currentPage else { return }
        calendarView.setCurrentPage(page, animated: true)
    }
    
    @objc func clickedCalendarBtn() {
        calendarView.setCurrentPage(Date(), animated: true)
    }
    
    @objc func clickedAddButton() {
        addAnimationView.play()
        
        self.present(AddingTodoViewController(), animated: true)
    }
    
    @objc func panView(_ swipe: UIPanGestureRecognizer) {
        switch calendarView.scope {
        case .month:
            changeWeekScope()
        case .week:
            changeMonthScope()
        default:
            return
        }
        
        calendarView.handleScopeGesture(swipe)
    }
    
    private func changeWeekScope() {
        UIView.animate(withDuration: 0.5) {
            self.leftArrowButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.rightArrowButton.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
        }
    }
    
    private func changeMonthScope() {
        UIView.animate(withDuration: 0.5) {
            self.leftArrowButton.transform = CGAffineTransform(rotationAngle: .pi)
            self.rightArrowButton.transform = .identity
        }
    }
}

// MARK: TableView delegate datasource
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier) as? TodoCell else {
            return UITableViewCell()
        }
        
        cell.updateTitle(todos[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        self.present(AddingTodoViewController(todoObject: todo), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UI
extension TodoViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureNavigationHeaderView()
        configureCalendarHeaderView()
        configureCalendarView()
        configureMinusView()
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
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarHeaderStackView.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        calendarHeightAnchor = calendarView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        calendarHeightAnchor?.isActive = true
    }
    
    private func configureMinusView() {
        let scopeGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        minusView.addGestureRecognizer(scopeGesture)
        view.addSubview(minusView)
        
        NSLayoutConstraint.activate([
            minusView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            minusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            minusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            minusView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: minusView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: FSCalendar delegate datasource
extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        changedTargetDate(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarHeaderLabel.text = Date.toString(calendar.currentPage)
        currentPage = calendar.currentPage
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [CustomColor.darkGreen]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [CustomColor.darkGray]
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightAnchor?.constant = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.eventIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
}
