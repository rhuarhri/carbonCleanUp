//
//  DonationTableViewCell.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 26/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class DonationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameTXT: UILabel!
    var name = ""
    
    @IBOutlet weak var descriptionTXT: UITextView!
    
    @IBOutlet weak var treeAmountTXT: UILabel!
    
    @IBOutlet weak var AddTreeStepper: UIStepper!
    
    var treeAmount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var action : (() -> Void)? = nil
    @IBAction func addBTNPressed(_ sender: Any) {
        action?()
        treeAmountTXT.text = treeAmount.description
    }
    
}
