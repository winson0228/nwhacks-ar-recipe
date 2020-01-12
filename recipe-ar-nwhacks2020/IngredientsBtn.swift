//
//  IngredientsBtn.swift
//  recipe-ar-nwhacks2020
//
//  Created by Winson Wong on 2020-01-11.
//  Copyright © 2020 Winson Wong. All rights reserved.
//

import UIKit

class IngredientsBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .lightGray
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        layer.cornerRadius = 10
    }
}
