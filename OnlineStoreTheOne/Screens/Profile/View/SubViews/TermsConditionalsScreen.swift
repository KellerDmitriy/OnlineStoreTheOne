//
//  TermsConditionalsScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 17.04.2024.
//

import UIKit

class TermsConditionalsScreen: UIViewController {
    private lazy var termsTextView: UITextView = {
        let text = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        text.text = termsText
        text.isEditable = false
        text.isSelectable = true
        text.textAlignment = .justified
        text.font = UIFont.makeTypography(.bold, size: 17)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addAction(self.back(), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = Colors.darkArsenic
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.isHidden = true
        setUpView()
        setConstrains()
        
    }
    
    func back() -> UIAction {
        let act = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
            
            print("back")
        }
        return act
    }
}

private extension TermsConditionalsScreen {
    
    func setUpView() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(termsTextView)
    }
    
    func setConstrains() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            
            termsTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            termsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            termsTextView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            termsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
//    func back() -> UIAction {
//        let act = UIAction { _ in
//            self.navigationController?.popViewController(animated: true)
//            
//            print("back")
//        }
//        return act
//    }
    
   
}

let termsText = """
**Terms and Conditions**

These Terms and Conditions (the «Terms») govern the relationship between the Seller and the Buyer on the Marketplace.

1. **Definitions.**

The following terms are used in these Terms:
* «Seller» — a legal entity or individual who sells products or services on the Marketplace;
* «Buyer» — a person who purchases products or services on the Marketplace;
* «Marketplace» — the online platform where Sellers and Buyers interact;
* «Products» — goods or services offered for sale on the Marketplace;
* «Payment» — the process of transferring funds from the Buyer to the Seller for the purchase of Products;
* «Delivery» — the process of delivering Products from the Seller to the Buyer.

2. **General Terms.**

2.1. The Seller agrees to sell Products in accordance with the terms of the Marketplace. The Buyer agrees to purchase Products in accordance with these Terms.

2.2. The Seller is responsible for the accuracy and completeness of the information about Products, including their description, price, and availability.

2.3. The Seller is responsible for the quality of Products and their compliance with applicable laws and regulations.

2.4. The Buyer is responsible for providing accurate and complete information about themselves, including their contact information and payment details.

2.5. The Buyer is responsible for paying for Products in a timely manner.

3. **Payment Terms.**

3.1. Payment for Products must be made in the currency specified on the Marketplace.

3.2. Payment must be made using a payment method accepted by the Marketplace.

3.3. The Buyer must provide accurate and complete payment information.

4. **Delivery Terms.**

4.1. Delivery of Products must be carried out in accordance with the terms of the Marketplace.

4.2. The Seller must provide accurate and complete delivery information.

5. **Refunds and Returns.**

5.1. The Buyer has the right to return Products within the specified period of time.

5.2. The Buyer must return Products in their original condition.

5.3. The Buyer is responsible for the cost of returning Products.

6. **Liability.**

6.1. The Marketplace is not responsible for any loss or damage to Products during delivery
"""
