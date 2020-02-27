//
//  CustomTextButton.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 27/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class CustomTextButton: UIButton {
    
    private let textColor : UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private let backColor : UIColor = UIColor(red: 0.08, green: 0.44, blue: 0.03, alpha: 1.0)

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
        layer.backgroundColor = backColor.cgColor
        setTitleColor(textColor, for: .normal)
        layer.cornerRadius = 15.0
        titleLabel?.font = UIFont(name: "Helvetica", size:25)
    }

}
