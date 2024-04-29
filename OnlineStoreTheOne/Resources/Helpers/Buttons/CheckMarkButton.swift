//
//  CheckMarkButton.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 23.04.2024.
//

import UIKit

final class CheckMarkButton: UIButton {
    var isCheckedMark: ((Bool) -> Void)?
    
    var isChecked: Bool = true {
        didSet {
            isChecked
            ? self.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            : self.setImage(UIImage(systemName: "square"), for: .normal)
            self.tintColor = isChecked ? Colors.greenSheen : Colors.gray
        }
    }
    
    private lazy var checkMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = Colors.gray
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setConstraints()
    }
    
    @objc private func buttonTapped() {
        isChecked.toggle()
        isCheckedMark?(isChecked)
    }
    
    private func setupViews() {
        addSubview(checkMarkButton)
    }
    
    private func setConstraints() {
        checkMarkButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


