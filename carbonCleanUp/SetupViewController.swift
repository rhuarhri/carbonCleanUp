//
//  SetupViewController.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 13/02/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var itemsTV: UITableView!
    
    var exampleItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exampleItems = [
        "Name:dads car  Type:Large",
        "Name:mac   Type:Small",
        "Name:fridge    Type:Large"]
        
        self.itemsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func GoToBTNPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToHomeScreen", sender: nil)
    }
    
    @IBAction func electricalItemsQuestionBTNPressed(_ sender: Any) {
        
        let instructions : String = "Small electrical items are anything between a kettle to a TV. \nMedium electrical items are anything that is the same size as a vacuum cleaner. \nLarge electrical items are anything like a fridge or washing machine. \nAnything smaller than the small option you can ignore."
        
        performSegue(withIdentifier: "showHelpPopup", sender: instructions)
    }
    
    @IBAction func vehiclesQuestionBTNPressed(_ sender: Any) {
        
        let instructions : String = "Small vehicles are anything smaller or the same size as a hatchback like a mini copper. \nLarge vehicles are anything that is the same size as a people carrier or 4 by 4 like a land rover. \nVans are anything bigger than a 4 by 4 like a ford transit. \nLorries are anything larger than a van like a tractor. \nIf you have a hybrid vehicle move it to on option below so a large hybrid is considered a small vehicle. \nIf you are unsure which option to choose, pick the higher option for example if you have a choose between small and large pick large. \nThis question does not apply to electric cars."
        
        performSegue(withIdentifier: "showHelpPopup", sender: instructions)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHelpPopup"
        {
            if let destination = segue.destination as? PopupViewController
            {
                destination.message = (sender! as? String)!
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = exampleItems[indexPath.row]
        
        return cell
    }

    
}
