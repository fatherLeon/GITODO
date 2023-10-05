//
//  AddingTodoViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/10.
//

import UIKit
import RxSwift
import RxCocoa

final class AddingTodoViewController: UIViewController {
    
    private let viewModel: AddingTodoViewModel
    private let disposeBag = DisposeBag()
    private weak var delegate: AddingTodoDelegate?
    
    private let minusView: MinusView = {
        let view = MinusView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let todoTitleTextField: UITextField = {
        let view = UITextField()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "할 일을 입력해주세요"
        view.font = .boldSystemFont(ofSize: 17)
        
        return view
    }()
    private let todoMemoTextView: UITextView = {
        let view = UITextView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "메모를 입력해주세요"
        view.font = .preferredFont(forTextStyle: .callout)
        view.textColor = .placeholderText
        
        return view
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        
        return picker
    }()
    private let saveButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    private lazy var buttonsStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        
        return hStack
    }()
    
    init(todoObject: TodoObject? = nil, targetDate: Date = Date(), delegate: AddingTodoDelegate? = nil) {
        self.viewModel = AddingTodoViewModel(targetDate: targetDate, todoObject: todoObject)
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(false)
        
        super.viewWillDisappear(animated)
    }
    
    private func binding() {
        todoTitleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.todoTitleText)
            .disposed(by: disposeBag)
        
        todoMemoTextView.rx.text
            .orEmpty
            .bind(to: viewModel.todoMemoText)
            .disposed(by: disposeBag)
        
        todoMemoTextView.rx.didBeginEditing
            .subscribe { _ in
                if self.todoMemoTextView.text == "메모를 입력해주세요" {
                    self.todoMemoTextView.text = ""
                    self.todoMemoTextView.textColor = .label
                }
            }
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: viewModel.todoDate)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe { _ in
                let result = self.viewModel.processTodo()
                
                if result {
                    self.delegate?.updateTableView(by: self.datePicker.date)
                    self.dismiss(animated: true)
                } else {
                    self.showAlert(title: "저장에 실패하였습니다.", message: nil)
                }
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe { _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.isWritingCompleted
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: UI
extension AddingTodoViewController {
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        configureMinusView()
        configureHeadTextField()
        configureContentTextView()
        configureSaveAndCancelButton()
        configureDatePicker()
    }
    
    private func configureMinusView() {
        self.view.addSubview(minusView)
        
        NSLayoutConstraint.activate([
            minusView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            minusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            minusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            minusView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    private func configureHeadTextField() {
        todoTitleTextField.text = viewModel.todoObject?.title ?? ""
        
        self.view.addSubview(todoTitleTextField)
        
        todoTitleTextField.layer.cornerRadius = 10
        todoTitleTextField.layer.borderWidth = 0.25
        todoTitleTextField.layer.borderColor = UIColor.gray.cgColor
        
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: todoTitleTextField.frame.height))
        todoTitleTextField.leftView = paddingView
        todoTitleTextField.leftViewMode = .always
        
        todoTitleTextField.rightView = paddingView
        todoTitleTextField.rightViewMode = .always
        
        NSLayoutConstraint.activate([
            todoTitleTextField.topAnchor.constraint(equalTo: minusView.bottomAnchor, constant: 10),
            todoTitleTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            todoTitleTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            todoTitleTextField.heightAnchor.constraint(equalToConstant: self.view.frame.height / 20)
        ])
    }
    
    private func configureContentTextView() {
        todoMemoTextView.text = viewModel.todoObject?.memo ?? "메모를 입력해주세요"
        
        self.view.addSubview(todoMemoTextView)
        
        todoMemoTextView.textColor = .secondaryLabel
        todoMemoTextView.layer.borderColor = UIColor.gray.cgColor
        todoMemoTextView.layer.borderWidth = 0.25
        todoMemoTextView.layer.cornerRadius = 10
        todoMemoTextView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        NSLayoutConstraint.activate([
            todoMemoTextView.topAnchor.constraint(equalTo: todoTitleTextField.bottomAnchor, constant: 10),
            todoMemoTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            todoMemoTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            todoMemoTextView.heightAnchor.constraint(greaterThanOrEqualTo: todoTitleTextField.heightAnchor, multiplier: 1.5)
        ])
    }
    
    private func configureDatePicker() {
        if viewModel.todoObject == nil {
            datePicker.datePickerMode = .time
        } else {
            datePicker.datePickerMode = .dateAndTime
        }
        
        self.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: todoMemoTextView.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor),
            datePicker.heightAnchor.constraint(lessThanOrEqualTo: todoMemoTextView.heightAnchor, multiplier: 0.5)
        ])
        
        guard let todo = viewModel.todoObject else {
            datePicker.setDate(viewModel.targetDate, animated: true)
            return
        }
        
        var components = DateComponents()
        
        components.year = Int(todo.year)
        components.month = Int(todo.month)
        components.day = Int(todo.day)
        components.hour = Int(todo.hour)
        components.minute = Int(todo.minute)
        
        let targetedDate = Calendar.current.date(from: components) ?? viewModel.targetDate
        
        datePicker.setDate(targetedDate, animated: true)
    }
    
    private func configureSaveAndCancelButton() {
        self.view.addSubview(buttonsStack)
        
        buttonsStack.spacing = self.view.frame.width / 20
        
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -10),
            buttonsStack.heightAnchor.constraint(equalToConstant: self.view.frame.height / 20)
        ])
    }
}
