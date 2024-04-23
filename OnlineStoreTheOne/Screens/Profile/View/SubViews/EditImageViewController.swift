//
//  EditImageViewController.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 19.04.2024.
//

import UIKit

final class EditImageViewController: UIViewController {
    //MARK: - UI elements
    
    var completion: ((UIImage) -> ())?
    
    private lazy var changeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.addBorder()
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = NewLabelFactory(text: "Change your picture", font: FontType.extraBold, size: 20).createLabel()
        label.textColor = .black
        return label
    }()
    
    private lazy var takePhotoBtn: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Take a photo",
            type: .imageEditButtons,
            name: "PhotoIcon",
            action: cameraImageAction(),
            textColor: .black)
            .createButtonWithLabel()
        return button
    }()
    
    private lazy var choosePhotoBtn: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Choose from your file",
            type: .imageEditButtons,
            name: "FileIcon",
            action: chooseImageAction(),
            textColor: .black)
            .createButtonWithLabel()
        return button
    }()
    
    private lazy var deletePhotoBtn: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Delete Photo",
            type: .imageEditButtons,
            name: "TrashIcon",
            action: deleteImageAction(),
            textColor: Colors.red)
            .createButtonWithLabel()
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(primaryAction: closeAction())
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.tintColor = Colors.lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var btnStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.addArrangedSubview(takePhotoBtn.0)
        stack.addArrangedSubview(choosePhotoBtn.0)
        stack.addArrangedSubview(deletePhotoBtn.0)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        setUpView()
        setConstraint()
    }
       
}

//MARK: - Extension
private extension EditImageViewController {
    //MARK: - Actions
    
    func cameraImageAction() -> UIAction {
        UIAction { [weak self] _ in
            self?.chooseImage(source: .camera)
        }
    }
    
    func chooseImageAction() -> UIAction {
        UIAction { [weak self] _ in
            self?.chooseImage(source: .photoLibrary)
        }
    }
    func deleteImageAction() -> UIAction {
        UIAction { [weak self] _ in
            let image = UIImage(named: "NoPhoto")
            self!.completion?(image!)
            self?.dismiss(animated: true)
        }
    }
    
    func closeAction() -> UIAction {
        UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    //MARK: - Set up view
    func setUpView() {
        view.addSubview(changeView)
        view.addSubview(label)
        view.addSubview(btnStack)
        view.addSubview(takePhotoBtn.1)
        view.addSubview(takePhotoBtn.2)
        view.addSubview(choosePhotoBtn.1)
        view.addSubview(choosePhotoBtn.2)
        view.addSubview(deletePhotoBtn.1)
        view.addSubview(deletePhotoBtn.2)
        view.addSubview(closeButton)
        
    }
    //MARK: - Set constraint
    func setConstraint() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: changeView.topAnchor, constant: 30),
            label.centerXAnchor.constraint(equalTo: changeView.centerXAnchor),
            
            changeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            changeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            changeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            changeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -320),
            
            btnStack.bottomAnchor.constraint(equalTo: changeView.bottomAnchor, constant: -20),
            btnStack.leadingAnchor.constraint(equalTo: changeView.leadingAnchor, constant: 20),
            btnStack.trailingAnchor.constraint(equalTo: changeView.trailingAnchor, constant: -20),
            
            takePhotoBtn.2.topAnchor.constraint(equalTo: takePhotoBtn.0.topAnchor, constant: 15.5),
            takePhotoBtn.2.leadingAnchor.constraint(equalTo: takePhotoBtn.0.leadingAnchor, constant: 15),
            takePhotoBtn.1.topAnchor.constraint(equalTo: takePhotoBtn.0.topAnchor, constant: 20),
            takePhotoBtn.1.leadingAnchor.constraint(equalTo: takePhotoBtn.2.trailingAnchor, constant: 40),
            
            choosePhotoBtn.2.topAnchor.constraint(equalTo: choosePhotoBtn.0.topAnchor, constant: 15.5),
            choosePhotoBtn.2.leadingAnchor.constraint(equalTo: choosePhotoBtn.0.leadingAnchor, constant: 15),
            choosePhotoBtn.1.topAnchor.constraint(equalTo: choosePhotoBtn.0.topAnchor, constant: 20),
            choosePhotoBtn.1.leadingAnchor.constraint(equalTo: choosePhotoBtn.2.trailingAnchor, constant: 40),
            
            deletePhotoBtn.2.topAnchor.constraint(equalTo: deletePhotoBtn.0.topAnchor, constant: 15.5),
            deletePhotoBtn.2.leadingAnchor.constraint(equalTo: deletePhotoBtn.0.leadingAnchor, constant: 15),
            deletePhotoBtn.1.topAnchor.constraint(equalTo: deletePhotoBtn.0.topAnchor, constant: 20),
            deletePhotoBtn.1.leadingAnchor.constraint(equalTo: deletePhotoBtn.2.trailingAnchor, constant: 40),
            
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.topAnchor.constraint(equalTo: changeView.topAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: changeView.trailingAnchor, constant: -20)
            
        ])
    }
}
//
//private extension UIView {
//    //MARK: - Add border
//    func addBorder() {
//        let height: CGFloat = 0.3
//        let separator = UIView()
//        separator.backgroundColor = Colors.red.withAlphaComponent(0.3)
//        separator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        separator.frame = CGRect(
//            x: 0,
//            y: frame.height + 80,
//            width: frame.width,
//            height: 120
//        )
//        addSubview(separator)
//    }
//}

// MARK: - Protocols for load Image from gallery
extension EditImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        completion?(image)
        
        picker.dismiss(animated: true) { [weak self] in
            self?.dismiss(animated: true)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func chooseImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true)
        }
    }
}
