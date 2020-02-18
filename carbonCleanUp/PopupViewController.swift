//
//  PopupViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 13/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        helpInstructTXT.text = message
    }
    
    public var message = "no message found"
    
    @IBOutlet weak var helpInstructTXT: UITextView!
    
    @IBAction func dismisBTNPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
