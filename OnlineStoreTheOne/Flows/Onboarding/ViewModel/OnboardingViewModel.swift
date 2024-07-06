//
//  OnboardingViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class OnboardingViewModel {
    // MARK: - Properties
    weak var coordinator: IOnboardingCoordinator?
    
    private let imageArray = [
        Resources.Image.onboarding1,
        Resources.Image.onboarding2,
        Resources.Image.onboarding3,
    ]
    
    private var currentIndex = 0
    
    //    MARK: - Init
    init(coordinator: IOnboardingCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func currentImage() -> UIImage? {
        guard currentIndex < imageArray.count else { return nil }
        return imageArray[currentIndex]
    }
    
    func nextImage() -> UIImage? {
        currentIndex += 1
        guard currentIndex < imageArray.count else { return nil }
        return imageArray[currentIndex]
    }
}
