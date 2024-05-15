//
//  OnboardingViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class OnboardingViewModel {
    // MARK: - Properties
    
    private let imageArray = [
        UIImage(named: "Onboarding1"),
        UIImage(named: "Onboarding2"),
        UIImage(named: "Onboarding3"),
    ]
    private var currentIndex = 0
    
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
