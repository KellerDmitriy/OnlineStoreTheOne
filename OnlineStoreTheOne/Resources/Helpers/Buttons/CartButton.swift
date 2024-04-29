//
//  CartButton.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 19.04.2024.
//

import UIKit
import SnapKit

protocol CartButtonDelegate: AnyObject {
    func cartButton(_ cartButton: CartButton, didUpdateCount count: Int)
}

final class CartButton: UIButton {
    //MARK: - Public Properties
    var count = 0 {
        didSet {
            configure()
            setCountToCountLabel()
            delegate?.cartButton(self, didUpdateCount: count)
        }
    }
    weak var delegate: CartButtonDelegate?
    //    MARK: - UI elements
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.makeTypography(.bold, size: 9)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var roundView: UIView = {
        let view = UIView()
        let height: CGFloat = 11.5
        let cornerRadius = height / 2
        view.frame.size = CGSize(width: height, height: height)
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = Colors.red
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cartImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "cart")
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        layoutViews()
        addAnimationEffect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetupViews & Configure
private extension CartButton {
    func setCountToCountLabel() {
         countLabel.text = "\(count)"
     }
    
    func configure() {
        if count == 0 {
            roundView.isHidden = true
        } else {
            roundView.isHidden = false
        }
    }
    
    func addAnimationEffect() {
        makeSystem(self)
    }
    
    func addViews() {
        addSubview(cartImageView)
        cartImageView.addSubview(roundView)
        roundView.addSubview(countLabel)
    }
    
    func layoutViews() {
        
        cartImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(28)
        }
        
        roundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
