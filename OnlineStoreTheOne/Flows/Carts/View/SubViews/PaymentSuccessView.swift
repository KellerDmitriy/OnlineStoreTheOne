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
    
    private lazy var pdfButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "order_invoice",
            chevron: "PDFIcon",
            action: UIAction { [weak self] _ in
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
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
        
        view.addSubview(successImage)
        view.addSubview(congratsLabel)
        view.addSubview(miniLabel)
        view.addSubview(pdfButton)
        view.addSubview(downloadImage)
        view.addSubview(continueButton)
    }
    //MARK: - Set constraint
    func setConstraint() {
        NSLayoutConstraint.activate([
            successImage.heightAnchor.constraint(equalToConstant: 150),
            successImage.widthAnchor.constraint(equalToConstant: 150),
            successImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            congratsLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 10),
            congratsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            congratsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            
            miniLabel.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: 10),
            miniLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            miniLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            
            pdfButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15.5),
            pdfButton.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 15),
            pdfButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            pdfButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 40),
            
            downloadImage.topAnchor.constraint(equalTo: pdfButton.topAnchor, constant: 15.5),
            downloadImage.trailingAnchor.constraint(equalTo: pdfButton.trailingAnchor, constant: -35),
            
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.topAnchor.constraint(equalTo: pdfButton.bottomAnchor, constant: 15),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
}
