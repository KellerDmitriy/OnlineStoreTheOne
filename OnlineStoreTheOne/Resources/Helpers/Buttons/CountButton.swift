//
//  CountButton.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 24.04.2024.
//

import UIKit

final class CountButton: UIView {
    
    var isCounter: Int = 0 {
        didSet {
            
        }
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        let width: CGFloat = 20
        view.frame.size = CGSize(width: width, height: width/2)
        view.layer.cornerRadius = 5
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
private lazy var minusButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 15
    button.layer.borderColor = Colors.lightGray.cgColor
    button.layer.borderWidth = 1
    button.titleLabel?.text = "-"
    button.tintColor = .darkGray
    button.backgroundColor = .white
    button.snp.makeConstraints { make in
        make.height.equalTo(30)
        make.width.equalTo(30)
    }
    return button
}()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderColor = Colors.lightGray.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.text = "-"
        button.tintColor = .darkGray
        button.backgroundColor = .white
        button.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        return button
    }()
    
    override func awakeFromNib() {
        minusButton.addTarget(self, action:#selector(minusButtonTap(sender:)), for: UIControl.Event.touchUpInside)
    
    }
    
    @objc func minusButtonTap(sender: UIButton) {
        if sender == self {

        }
    }
}
