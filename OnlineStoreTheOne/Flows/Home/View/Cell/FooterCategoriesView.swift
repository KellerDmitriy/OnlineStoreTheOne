//
//  FooterCategoriesView.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 24.05.2024.
//

import UIKit
import SnapKit

final class FooterCategoriesView: UICollectionReusableView {
    static let reuseIdentifier = "FooterCategoriesView"
    
    lazy var allButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "All categories",
            chevron: "chevron.forward",
            action: UIAction { [weak self] _ in
                self?.allButtonTapped()
            },
            textColor: Colors.gray
        )
        
        return button.createButtonWithChevron()
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray.withAlphaComponent(0.5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(allButton)
        addSubview(separatorView)
    }
    
    
    private func setConstraints() {
        allButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(allButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.3)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func allButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("allCategoriesButtonTapped"), object: nil)
    }
}

