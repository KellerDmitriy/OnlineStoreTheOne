//
//  BackButton.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 24.05.2024.
//

import UIKit

final class BackButton: UIButton {

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
        setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.tintColor = .systemGray
        self.imageView?.contentMode = .scaleToFill
    }

}
