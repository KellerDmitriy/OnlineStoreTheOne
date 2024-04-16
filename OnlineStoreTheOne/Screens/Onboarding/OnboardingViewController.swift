//
//  OnboardingViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 16.04.2024.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
     //MARK: - Private Properties
    private let imageArray = [
        UIImage(named: "Onboarding1"),
        UIImage(named: "Onboarding2"),
        UIImage(named: "Onboarding3"),
    ]
    private let backgroundImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    private var index = 0
    
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        
        backgroundImageView.image = imageArray[index]
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

     //MARK: - Objc Methods
    @objc private func handleTap() {
        index += 1
        guard index < 3 else {
            UserDefaults.standard.set(true, forKey: "OnboardCompleted")
            let tabBarController = TabBarController()
            navigationController?.pushViewController(tabBarController, animated: true)
            return
        }
        backgroundImageView.image = imageArray[index]
    }
}
