//
//  TermsConditionalViewController.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 17.04.2024.
//

import UIKit

final class TermsConditionalViewController: UIViewController {
    //MARK: - UI elements
    private lazy var termsTextView: UITextView = {
        let text = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        text.isEditable = false
        text.isSelectable = true
        text.textAlignment = .justified
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setConstrains()
        applyAttributedText()
    }
}

//MARK: - Extension
private extension TermsConditionalViewController {
    
    //MARK: - Set up view
    func setUpView() {
        view.backgroundColor = .white
        
        view.addSubview(termsTextView)
        
        navigationItem.title = "Terms & Conditional"
        navigationController?.setupNavigationBar()
        navigationController?.navigationBar.addBottomBorder()
        
    }
    
    //MARK: - Set constraint
    func setConstrains() {
        NSLayoutConstraint.activate([
            
            termsTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            termsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            termsTextView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            termsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

private extension TermsConditionalViewController {
    // MARK: - Setting up the text layout
    func applyAttributedText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        var sections = getTranslatedStrings()
        
        let attributedText = NSMutableAttributedString()
        
        for section in sections {
            
            let titleFont = UIFont.makeTypography(.bold, size: 17)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .paragraphStyle: paragraphStyle
            ]
            let attributedTitle = NSAttributedString(string: section.title, attributes: titleAttributes)
            
            // Text attributes
            let textFont = UIFont.makeTypography(.light, size: 16)
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: textFont,
                .paragraphStyle: paragraphStyle
            ]
            let attributedSectionText = NSAttributedString(string: section.text, attributes: textAttributes)
            
            attributedText.append(attributedTitle)
            attributedText.append(attributedSectionText)
        }
        
        termsTextView.attributedText = attributedText
    }
    
    //MARK: - Text
    func getTranslatedStrings() -> [(title: String, text: String)] {
        
        let firstSection = """


The following terms are used in these Terms:
* «Seller» — a legal entity or individual who sells products or services on the Marketplace;
* «Buyer» — a person who purchases products or services on the Marketplace;
* «Marketplace» — the online platform where Sellers and Buyers interact;
* «Products» — goods or services offered for sale on the Marketplace;
* «Payment» — the process of transferring funds from the Buyer to the Seller for the purchase of Products;
* «Delivery» — the process of delivering Products from the Seller to the Buyer.


"""
        let secondSection = """


2.1. The Seller agrees to sell Products in accordance with the terms of the Marketplace. The Buyer agrees to purchase Products in accordance with these Terms.
2.2. The Seller is responsible for the accuracy and completeness of the information about Products, including their description, price, and availability.
2.3. The Seller is responsible for the quality of Products and their compliance with applicable laws and regulations.
2.4. The Buyer is responsible for providing accurate and complete information about themselves, including their contact information and payment details.
2.5. The Buyer is responsible for paying for Products in a timely manner.


"""
        let thirdSection = """


3.1. Payment for Products must be made in the currency specified on the Marketplace.
3.2. Payment must be made using a payment method accepted by the Marketplace.
3.3. The Buyer must provide accurate and complete payment information.


"""
        let fourthSection = """


4.1. Delivery of Products must be carried out in accordance with the terms of the Marketplace.
4.2. The Seller must provide accurate and complete delivery information.


"""
        let ffifthSection = """


5.1. The Buyer has the right to return Products within the specified period of time.
5.2. The Buyer must return Products in their original condition.
5.3. The Buyer is responsible for the cost of returning Products.


"""
        
        let sixthSection = """


6.1. The Marketplace is not responsible for any loss or damage to Products during delivery


"""
        
        let firstSectionTitle = "1. Definitions."
        let secondSectionTitle = "2. General Terms."
        let thirdSectionTitle = "3. Payment Terms."
        let fourthSectionTitle = "4. Delivery Terms."
        let fifthSectionTitle = "5. Refunds and Returns."
        let sixthSectionTitle = "6. Liability."
        
        let strings = [
            (firstSectionTitle, firstSection),
            (secondSectionTitle, secondSection),
            (thirdSectionTitle, thirdSection),
            (fourthSectionTitle, fourthSection),
            (fifthSectionTitle, ffifthSection),
            (sixthSectionTitle, sixthSection)
        ]
        return strings
    }
}

