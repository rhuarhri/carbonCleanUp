//
//  AchievementsTableViewCell.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 24/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameTXT: UILabel!
    @IBOutlet weak var progressPB: UIProgressView!
    
    var faceShareBTNPressed : (() -> Void)? = nil
    
    //@IBOutlet weak var facebookShareBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func facebookShareBTN(_ sender: Any){
        faceShareBTNPressed?()
        //print("button pressed")
    }

}
