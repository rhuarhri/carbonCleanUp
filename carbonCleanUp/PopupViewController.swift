//
//  PopupViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 13/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit
import Firebase

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //helpInstructTXT.text = message
        
        let collRef : CollectionReference = Firestore.firestore().collection("instructions")
        
        let helpQuery = collRef.whereField("type", isEqualTo: message)
        
        helpQuery.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                self.message = result["help"] as? String ?? "Unable to find anything."
                self.helpInstructTXT.text = self.message
                //self.performSegue(withIdentifier: "showHelpPopup", sender: instructions)
            }
        }
        }
        
    }
    
    public var message : String = "no message found"
    
    @IBOutlet weak var helpInstructTXT: UITextView!
    
    @IBAction func dismisBTNPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
