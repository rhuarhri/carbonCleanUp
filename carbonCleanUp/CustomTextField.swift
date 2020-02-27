//
//  CustomTextField.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 27/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    private let borderColour : UIColor = UIColor(red: 0.08, green: 0.44, blue: 0.03, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup()
    {
        layer.borderColor = borderColour.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 8.0
    }
    
}
