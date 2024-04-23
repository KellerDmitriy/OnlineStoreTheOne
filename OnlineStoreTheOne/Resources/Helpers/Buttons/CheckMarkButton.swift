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
            if isChecked == true {
                self.checkMarkView.backgroundColor = Colors.greenSheen
                self.setImage(
                    UIImage(named: "CheckMark"),
                    for: .selected
                )
            } else {
                self.checkMarkView.backgroundColor = .white
                self.setImage(
                    nil,
                    for: .normal
                )
            }
        }
    }
    
    private lazy var checkMarkView: UIView = {
        let view = UIView()
        let height: CGFloat = 20
        view.frame.size = CGSize(width: height, height: height)
        view.layer.borderColor = Colors.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked.toggle()
        }
    }
}



