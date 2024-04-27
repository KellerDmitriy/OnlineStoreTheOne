//
//  CheckMarkButton.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 23.04.2024.
//

import UIKit

final class CheckMarkButton: UIButton {
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.checkMarkButton.backgroundColor = Colors.greenSheen
                self.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                self.checkMarkButton.backgroundColor = .white
                self.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
    
    private lazy var checkMarkButton: UIButton = {
        let button = UIButton()
        let height: CGFloat = 25
        button.frame.size = CGSize(width: height, height: height)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = Colors.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setConstraints()
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    private func setupViews() {
        addSubview(checkMarkButton)
    }
    
    private func setConstraints() {
        checkMarkButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func buttonClicked() {
        isChecked.toggle()
    }
}


