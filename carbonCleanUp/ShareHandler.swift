//
//  ShareHandler.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 08/04/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import Foundation
import Social

class ShareHandler
{
    var post : SLComposeViewController? = nil
    
    func shareOnFacebook(achievement : String)
    {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
        {
            post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            post?.setInitialText("Just got the \(achievement) achievemtn")
        }
        else{
            showError()
        }
    }
    
    var error : UIAlertController? = nil
    
    func showError()
    {
        error = UIAlertController(title: "Error", message: "You need to sign in before you can share", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        error?.addAction(action)
    }
}
