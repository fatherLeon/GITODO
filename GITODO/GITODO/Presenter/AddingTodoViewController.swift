//
//  AddingTodoViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/10.
//

import UIKit

class AddingTodoViewController: UIViewController {
    
    private var pickedDate = Date()
    
    private let headTextField: UITextField = {
        let view = UITextField()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "할 일을 입력해주세요"
        view.font = .boldSystemFont(ofSize: 17)
        
        return view
    }()
    private let contentTextView: UITextView = {
        let view = UITextView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "할 일에 대한 메모를 입력해주세요"
        view.font = .preferredFont(forTextStyle: .callout)
        
        return view
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.datePickerMode = .dateAndTime
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc private func clickedSaveButton() {
        dismiss(animated: true)
    }
    
    @objc private func clickedCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let components = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: datePicker.date)
        
        print("\(components.month)-\(components.minute) \(components.hour):\(components.minute)")
        
        pickedDate = datePicker.date
    }
}


// MARK: UI
extension AddingTodoViewController {
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        configureHeadTextField()
        configureContentTextView()
        configureSaveAndCancelButton()
        configureDatePicker()
    }
    
    private func configureHeadTextField() {
        self.view.addSubview(headTextField)
        
        headTextField.layer.cornerRadius = self.view.frame.height / 40
        headTextField.layer.borderWidth = 0.25
        headTextField.layer.borderColor = UIColor.gray.cgColor
        
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: headTextField.frame.height))
        headTextField.leftView = paddingView
        headTextField.leftViewMode = .always
        
        headTextField.rightView = paddingView
        headTextField.rightViewMode = .always
        
        NSLayoutConstraint.activate([
            headTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headTextField.heightAnchor.constraint(equalToConstant: self.view.frame.height / 20)
        ])
    }
    
    private func configureContentTextView() {
        self.view.addSubview(contentTextView)
        
        contentTextView.textColor = .secondaryLabel
        contentTextView.layer.borderColor = UIColor.gray.cgColor
        contentTextView.layer.borderWidth = 0.25
        contentTextView.layer.cornerRadius = 10
        contentTextView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: headTextField.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureDatePicker() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentTextView.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor)
        ])
    }
    
    private func configureSaveAndCancelButton() {
        self.view.addSubview(buttonsStack)
        
        saveButton.addTarget(self, action: #selector(clickedSaveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickedCancelButton), for: .touchUpInside)
        
        buttonsStack.spacing = self.view.frame.width / 20
        
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStack.heightAnchor.constraint(equalToConstant: self.view.frame.height / 20)
        ])
    }
}
