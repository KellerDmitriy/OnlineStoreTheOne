//
//  CustomViewWithPicker.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit
import Combine

final class CustomViewWithPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let viewModel: CustomViewWithPickerViewModel
    private var subscriptions: Set<AnyCancellable> = []
    private let containerView = UIView()
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .makeTypography(.semiBold, size: 13)
        $0.textAlignment = .left
        $0.text = "Categories"
        return $0
    }(UILabel())
    
    private lazy var textField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .roundedRect
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.placeholderManagerFields.cgColor
        return $0
    }(UITextField())
    
    private lazy var imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ArrowDown")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    init(viewModel: CustomViewWithPickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let pickerView = UIPickerView()
    
    private var data: [String] = []
    
    var currentText: String? {
        textField.text
    }
    
    private func bind() {
        viewModel.$categoryList.sink { [weak self] newData in
            guard let self else { return }
            data = newData
            pickerView.reloadAllComponents()
        }.store(in: &subscriptions)
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        containerView.addSubview(imageView)
        [label, textField].forEach(stackView.addArrangedSubview(_:))
        setupPickerView()
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(246)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-10)
        }
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        textField.inputView = pickerView
        textField.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([flexibleSpace ,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = data[row]
    }
}
