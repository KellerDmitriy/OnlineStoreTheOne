//
//  EditImageView.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 19.04.2024.
//

import UIKit
import SnapKit

protocol EditImageViewDelegate: AnyObject {
    func takePhotoButtonTap()
    func choosePhotoButtonTap()
    func deletePhotoButtonTap()
}

final class EditImageView: UIView {
    
    //MARK: - Properties
    weak var delegate: EditImageViewDelegate?
    
    //MARK: - UI elements
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray.withAlphaComponent(0.5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = LabelFactory(
            text: "Change your picture",
            font: FontType.extraBold,
            size: 20
        ).createLabel()
        label.textColor = Colors.gray
        return label
    }()
    
    lazy var takePhotoButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Take a photo",
            chevron: "camera",
            action: UIAction { [weak self] _ in
                self?.cameraImageAction()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    lazy var choosePhotoButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Choose from your file",
            chevron: "folder",
            action: UIAction { [weak self] _ in
                self?.chooseImageAction()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var deletePhotoButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Delete Photo",
            chevron: "trash.fill",
            action: UIAction { [weak self] _ in
                self?.deleteImageAction()
            },
            textColor: Colors.red
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.addArrangedSubview(takePhotoButton)
        stack.addArrangedSubview(choosePhotoButton)
        stack.addArrangedSubview(deletePhotoButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Extension
private extension EditImageView {
    //MARK: - Actions
    
    private func deleteImageAction() {
        delegate?.deletePhotoButtonTap()
    }
    
    private func cameraImageAction() {
        delegate?.takePhotoButtonTap()
    }
    
    private func chooseImageAction() {
        delegate?.choosePhotoButtonTap()
    }
    
    //MARK: - Set up view
    func setupView() {
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(buttonsStack)
    }
    
    //MARK: - Set constraint
    func setConstraint() {
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(Constants.contentViewSize)
            make.width.equalTo(Constants.contentViewSize)
            make.centerX.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.titleLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.separatorTopOffset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.separatorHeight)
            make.bottom.equalTo(buttonsStack.snp.top).offset(Constants.separatorBottomOffset)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.buttonStackHorizontalInset)
            make.bottom.equalToSuperview().inset(Constants.buttonStackBottomInset)
            make.height.equalTo(Constants.buttonStackHeight)
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let separatorAlpha: CGFloat = 0.5
        static let titleLabelFontSize: CGFloat = 20
        static let buttonStackSpacing: CGFloat = 12
        static let contentViewSize: CGFloat = 300
        static let titleLabelTopOffset: CGFloat = 20
        static let separatorTopOffset: CGFloat = 20
        static let separatorHeight: CGFloat = 0.3
        static let separatorBottomOffset: CGFloat = -20
        static let buttonStackHorizontalInset: CGFloat = 12
        static let buttonStackBottomInset: CGFloat = 12
        static let buttonStackHeight: CGFloat = 180
    }

}

