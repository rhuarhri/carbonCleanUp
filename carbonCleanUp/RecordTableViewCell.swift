//
//  RecordTableViewCell.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 23/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameTXT: UITextView!
    
    @IBOutlet weak var timeSelector: UISegmentedControl!
    
    public var selectedValue : String = "Not used"
    @IBAction func timeSelectorChange(_ sender: Any) {
        selectedValue = timeSelector.titleForSegment(at: timeSelector.selectedSegmentIndex)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
