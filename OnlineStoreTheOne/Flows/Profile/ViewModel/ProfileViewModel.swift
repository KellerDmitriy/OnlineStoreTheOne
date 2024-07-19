//
//  ProfileViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 19.04.2024.
//

import Foundation
import FirebaseAuth

// MARK: - Protocols
protocol IProfileViewModel {
    func showTermAndConditionScene()
    func showTypeOfAccountScene()
    func signOutAction()
    func handleSignOutError(_ error: Error)
}

// MARK: - ViewModel
final class ProfileViewModel: IProfileViewModel {
    // MARK: - Properties
    private let storageService: StorageServiceProtocol
    private let coordinator: IProfileCoordinator
    private let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
    
    // MARK: - Initialization
    init(storageService: StorageServiceProtocol, coordinator: IProfileCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
    }
    
    // MARK: - Routes
    func showTermAndConditionScene() {
        coordinator.showTermAndConditionScene()
    }
    
    func showTypeOfAccountScene() {
        coordinator.showTypeOfAccountScene()
    }
    
    func signOutAction() {
        coordinator.showAlertController(
            title: Resources.Texts.attention,
            message: Resources.Texts.signOutMessage,
            titleDefaultAction: Resources.Texts.signOut,
            titleDestructiveAction: Resources.Texts.cancel
        ) { [weak self] in
            self?.signOut()
        }
    }
    
    // MARK: - Private Methods
    private func signOut() {
        authService.signOut { [weak self] error in
            if let error = error {
                self?.handleSignOutError(error)
            } else {
                self?.coordinator.finish()
            }
        }
    }
    
    func handleSignOutError(_ error: Error) {
        coordinator.showAlertController(
            title: Resources.Texts.errorTitle,
            message: error.localizedDescription,
            titleDefaultAction: Resources.Texts.ok,
            createAction: nil
        )
    }
}
