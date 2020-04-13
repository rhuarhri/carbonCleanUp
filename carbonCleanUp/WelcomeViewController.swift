//
//  WelcomeViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 17/03/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let notification = NotificationHandler()
        notification.displayNotification()
    }
    
    @IBAction func nextBTNPressed(_ sender: Any) {
        
        let dataManager : DatabaseManger = DatabaseManger()
        
        
        dataManager.setUp()
        var setupRequired : Bool = dataManager.databaseEmpty()
        
        if setupRequired == true
        {
            self.performSegue(withIdentifier: "showSetup", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "noSetup", sender: nil)
        }
        
        
        
    }
    
    
    
}
