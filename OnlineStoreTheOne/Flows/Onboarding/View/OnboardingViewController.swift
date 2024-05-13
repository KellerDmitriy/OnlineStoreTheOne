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
    private let coordinator: IOnboardingCoordinator?
    
    private let viewModel: OnboardingViewModel
    
    var didFinishOnboarding: (() -> Void)?
    
    private let backgroundImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    
    init(viewModel: OnboardingViewModel, coordinator: IOnboardingCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupViews()
        setupLayout()
        updateUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    //    MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
    }
    
    private func setupLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateUI() {
        guard let image = viewModel.currentImage() else { return }
        backgroundImageView.image = image
    }
    
     //MARK: - Objc Methods
    @objc private func handleTap() {
        guard let nextImage = viewModel.nextImage() else {
            navigateToNextScreen()
            return
        }
        backgroundImageView.image = nextImage
    }
    
    func navigateToNextScreen() {
        didFinishOnboarding?()
        if viewModel.isLastImage() {
            didFinishOnboarding?()
        }
    }
}


