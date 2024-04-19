//
//  EditImageScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 19.04.2024.
//

import UIKit

class EditImageScreen: UIViewController {
    
    private lazy var changeView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 328, height: 340))
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
      //не забудь вынести кнопки на передний план?
    }
}
