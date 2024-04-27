//
//  CountButton.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 24.04.2024.
//

import UIKit
import SnapKit

final class CounterActionButton: UIView {
    
    var count: Int = 0 {
        didSet {
            countLabel.text = "\(count)"
            updateTrashButtonState()
        }
    }
    
    private let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .ultraLight)
    
    // UI elements
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "\(count)"
        return label
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(
            systemName: "minus.circle",
            withConfiguration: configuration)?
            .withTintColor(Colors.gray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(
            systemName: "plus.circle",
            withConfiguration: configuration)?
            .withTintColor(Colors.gray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(
            systemName: "trash.circle",
            withConfiguration: configuration)?
            .withTintColor(Colors.gray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private let countStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

    
    // MARK: - Private methods
    private func setupViews() {
        [minusButton, countLabel, plusButton, trashButton]
            .forEach{ countStack.addArrangedSubview($0) }
        addSubview(countStack)
    }
    
    private func setConstraints() {
        countStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    private func updateTrashButtonState() {
        trashButton.isEnabled = count > 0
    }
}
