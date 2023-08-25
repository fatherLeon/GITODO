//
//  ViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/04.
//

import UIKit
import FSCalendar
import Lottie

protocol AddingTodoDelegate: AnyObject {
    func updateTableView(by date: Date)
}

final class TodoViewController: UIViewController {
    
    private let today = Date()
    private var selectedDate = Date()
    private var currentPage: Date?
    private var todos: [TodoObject] = []
    private let coredataManager = CoreDataManager.shared
    private let gitManager = GitManager()
    private var calendarHeightAnchor: NSLayoutConstraint?
    private lazy var gesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(calendarView.handleScopeGesture(_:)))
        
        gesture.delegate = self
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 2
        
        return gesture
    }()
    
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
        calendar.scrollDirection = .horizontal
        calendar.locale = Locale.current
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
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureGesture()
        
        leftArrowButton.addTarget(self, action: #selector(clickedLeftArrowBtn), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(clickedRightArrowBtn), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(clickedCalendarBtn), for: .touchUpInside)
        
        updateTableView(by: today)
        
        guard let commitsData = try? coredataManager.fetch(CommitByDateObject.self) as? [CommitByDateObject] ?? [] else { return }
        
        if commitsData.count == 0 {
            guard let before = Date().beforeOneYear else { return }
            
            gitManager.searchCommits(by: "fatherLeon/FOFMAP", perPage: 100, page: 1, since: before, until: Date()) { [weak self] commits in
                commits.forEach { gitCommit in
                    guard let date = Date.toISO8601Date(gitCommit.commit.author.date) else { return }
                    
                    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                    
                    guard let year = components.year,
                          let month = components.month,
                          let day = components.day else { return }
                    
                    let targetId = "\(year)-\(month)-\(day)"
                    
                    guard var targetData = try? self?.coredataManager.searchOne(targetId, type: CommitByDateObject.self) as? CommitByDateObject else {
                        try? self?.coredataManager.save(CommitByDateObject(year: year, month: month, day: day, storedDate: Date(), commitedNum: 1))
                        
                        return
                    }
                    
                    targetData.commitedNum += 1
                    
                    try? self?.coredataManager.update(storedDate: Date(), data: targetData, type: CommitByDateObject.self)
                }
                
                DispatchQueue.main.async {
                    self?.calendarView.reloadData()
                }
            }
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
        calendarView.setCurrentPage(today, animated: true)
    }
    
    @objc func clickedAddButton() {
        addAnimationView.play()
        
        presentAddingTodoVC(targetDate: selectedDate, delegate: self)
    }
    
    private func deleteTodo(todo: TodoObject) -> Bool {
        do {
            try coredataManager.delete(storedDate: todo.storedDate, type: TodoObject.self)
            return true
        } catch {
            showAlert(title: "삭제 실패", message: nil)
            return false
        }
    }
    
    private func fetchTodos(by date: Date) -> [TodoObject] {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return [] }
        
        let targetId = "\(year)-\(month)-\(day)"
        
        guard let todos = try? coredataManager.search(targetId, type: TodoObject.self) as? [TodoObject] else {
            return []
        }
        
        return todos
    }
    
    private func presentAddingTodoVC(todoObject: TodoObject? = nil, targetDate: Date, delegate: AddingTodoDelegate? = nil) {
        let targetVC = AddingTodoViewController(todoObject: todoObject, targetDate: targetDate, delegate: delegate)
        
        self.present(targetVC, animated: true)
    }
}

// MARK: AddingTodoDelegate
extension TodoViewController: AddingTodoDelegate {
    func updateTableView(by date: Date) {
        let todos = fetchTodos(by: date)
        
        self.todos = todos
        self.tableView.reloadData()
        self.calendarView.reloadData()
    }
}

// MARK: Gesture Delegate
extension TodoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.gesture.velocity(in: self.view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                return velocity.y == 0
            }
        }
        return shouldBegin
    }
}

// MARK: TableView delegate datasource
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let boundaryCellNum = 10
        
        if todos.count < boundaryCellNum {
            return boundaryCellNum
        } else {
            return todos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier) as? TodoCell,
              let title = todos[safe: indexPath.row]?.title else {
            return UITableViewCell()
        }
        
        cell.updateTitle(title)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todo = todos[safe: indexPath.row] else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        presentAddingTodoVC(todoObject: todo, targetDate: selectedDate, delegate: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = todos[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            let result = self?.deleteTodo(todo: todo) ?? true
            
            if result {
                self?.todos.remove(at: indexPath.row)
                tableView.reloadData()
                
                completion(true)
            }
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height / 2 / 10
    }
}

// MARK: Init Configuration
extension TodoViewController {
    private func configureView() {
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
        calendarView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        
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
    
    private func configureGesture() {
        self.view.addGestureRecognizer(gesture)
        self.tableView.panGestureRecognizer.require(toFail: gesture)
    }
}

// MARK: FSCalendar delegate datasource
extension TodoViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: date, at: position) as? CalendarCell else {
            return FSCalendarCell()
        }

        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return FSCalendarCell() }
        
        guard let count = (try? coredataManager.searchOne("\(year)-\(month)-\(day)", type: CommitByDateObject.self) as? CommitByDateObject)?.commitedNum else {
            cell.updateUI(.systemBackground)
            return cell
        }
        
        if count > 0 {
            cell.updateUI(CustomColor.darkGreen)
        } else {
            cell.updateUI(.systemBackground)
        }
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.updateTableView(by: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarHeaderLabel.text = Date.toString(calendar.currentPage)
        currentPage = calendar.currentPage
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if fetchTodos(by: date).count > 0 {
            return 1
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.darkGray]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [.darkGray]
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightAnchor?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
