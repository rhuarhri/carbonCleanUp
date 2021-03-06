//
//  UiSetup.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 12/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit


class UiSetup: NSObject {
    
    let primaryColor = UIColor(red: 0.30, green: 0.62, blue: 0.23, alpha: 1.0);
    let primaryLightColor = UIColor(red: 0.50, green: 0.82, blue: 0.41, alpha: 1.0);
    let primaryDarkColor = UIColor(red: 0.08, green: 0.44, blue: 0.03, alpha: 1.0);
    let primaryTextColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
    
    func setBackground(background : UIView)
    {
        background.backgroundColor = primaryColor
    }

}
