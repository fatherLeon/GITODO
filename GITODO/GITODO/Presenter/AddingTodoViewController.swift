//
//  AddingTodoViewController.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/10.
//

import UIKit

class AddingTodoViewController: UIViewController {

    private let headTextField: UITextField = {
        let view = UITextField()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "할 일을 입력해주세요"
        view.font = .preferredFont(forTextStyle: .headline)
        
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
        picker.datePickerMode = .time
        
        return picker
    }()
    private let saveButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        
        return button
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        
        return button
    }()
    private lazy var buttonsStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = self.view.frame.width / 10
        
        return hStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: headTextField.bottomAnchor, constant: 5),
            contentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureDatePicker() {
        self.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor)
        ])
    }
    
    private func configureSaveAndCancelButton() {
        self.view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStack.heightAnchor.constraint(equalToConstant: self.view.frame.height / 20)
        ])
    }
}
