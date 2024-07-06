//
//  LocationView.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 30.05.2024.
//

import UIKit
import SnapKit

protocol LocationViewDelegate: AnyObject {
    func changeDeliveryAddressTapped()
}

final class LocationView: UIView {
    
    weak var delegate: LocationViewDelegate?
    
    var deliveryAddress = "\(Country.germany.capitalized) - \(Country.germany.capital)" {
        didSet {
            changeDeliveryAddressButton.configuration?.title = deliveryAddress
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.makeTypography(.semiBold, size: 12)
        label.textColor = .label.withAlphaComponent(0.5)
        label.text = Resources.Text.deliveryAddress
        return label
    }()
    
    private lazy var changeDeliveryAddressButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        button.configuration?.baseForegroundColor = Colors.darkArsenic
        button.configuration?.title = deliveryAddress
        button.configuration?.titleAlignment = .leading
        button.configuration?.image = Resources.Image.chevronDown?.resizedImage(
           Size: CGSize(width: 14, height: 8)
        )
        button.configuration?.imagePlacement = .trailing
        button.configuration?.imagePadding = 5
    
        return button
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setup() {
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        addSubview(changeDeliveryAddressButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        changeDeliveryAddressButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        changeDeliveryAddressButton.showsMenuAsPrimaryAction = true
        changeDeliveryAddressButton.menu = buttonMenu()
    }
    
    
    @objc private func changeAddress() {
        delegate?.changeDeliveryAddressTapped()
    }

    func buttonMenu() -> UIMenu {
       var menuActions = [UIAction]()
        for country in Country.allCases {
            let action = UIAction(title: "\(country.capitalized) - \(country.capital)", image: nil) { action in
                self.deliveryAddress = "\(country.capitalized) - \(country.capital)"
            }
            menuActions.append(action)
        }
        
        return  UIMenu(title: "", options: .displayInline, children: menuActions)
    }
    
    enum Country: CaseIterable {
        case china, japan, unitedStates, unitedKingdom, russia, india, brazil, germany, france, australia
        
        var capitalized: String {
                switch self {
                case .china: return "China"
                case .japan: return "Japan"
                case .unitedStates: return "United States"
                case .unitedKingdom: return "United Kingdom"
                case .russia: return "Russia"
                case .india: return "India"
                case .brazil: return "Brazil"
                case .germany: return "Germany"
                case .france: return "France"
                case .australia: return "Australia"
                }
            }
        
        var capital: String {
            switch self {
            case .china: return "Beijing"
            case .japan: return "Tokyo"
            case .unitedStates: return "Washington D. C."
            case .unitedKingdom: return "London"
            case .russia: return "Moscow"
            case .india: return "NewDelhi"
            case .brazil: return "Brasilia"
            case .germany: return "Berlin"
            case .france: return "Paris"
            case .australia: return "Canberra"
            }
        }
    }
}

