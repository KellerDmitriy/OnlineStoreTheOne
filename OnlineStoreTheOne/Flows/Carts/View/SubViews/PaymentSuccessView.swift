//
//  PaymentSuccessView.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 22.04.2024.
//

import UIKit

final class PaymentSuccessView: UIViewController {
    
    //MARK: - UI elements
    
    private lazy var successImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "PaymentSucessIcon")
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 75
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var congratsLabel: UILabel = {
        let label = LabelFactory(text: "Congrats! your payment is successfully", font: .extraBold, size: 22).createLabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var miniLabel: UILabel = {
        let label = LabelFactory(text: "Track your order or just chat directly to the seller. Download order summary in down bellow", font: .light, size: 14).createLabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var downloadImage: UIView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: "DownloadIcon")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        let button = FilledButtonFactory(
            title: "Continue",
            type: .greenButton,
            action: UIAction { [weak self] _ in
//                self?.viewModel.deleteAllProducts()
                self?.dismiss(animated: true)
            })
            .createButton()
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            successImage,
            congratsLabel,
            miniLabel,
            downloadImage,
            continueButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setConstraint()
    }
}

//MARK: - Extension
private extension PaymentSuccessView {
    
    //MARK: - Set up view
    func setUpView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
    }
    
    //MARK: - Set constraint
    func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        successImage.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(successImage.snp.height)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
