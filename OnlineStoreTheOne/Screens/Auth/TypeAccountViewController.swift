//
//  TypeAccountViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import UIKit


final class TypeAccountViewController: UIViewController {
    
    var completion: ((String) -> Void)?
    
    private lazy var managerButton: UIButton = {
        $0.setTitle("Manager", for: .normal)
        $0.backgroundColor = Colors.greenSheen
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .makeTypography(.medium, size: 16)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private lazy var userButton: UIButton = {
        $0.setTitle("User", for: .normal)
        $0.backgroundColor = Colors.greenSheen
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .makeTypography(.medium, size: 16)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private lazy var buttonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 20
        $0.axis = .vertical
        return $0
    }(UIStackView())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        title = "Choice type of account"
        view.addSubview(buttonsStackView)
        [managerButton, userButton].forEach(buttonsStackView.addArrangedSubview(_:))
    }
    
    private func setConstraints() {
        buttonsStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        managerButton.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        userButton.snp.makeConstraints {
            $0.height.equalTo(46)
        }
    }
    
    @objc private func tapButton(sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        completion?(text)
        navigationController?.popViewController(animated: true)
    }
   
}
