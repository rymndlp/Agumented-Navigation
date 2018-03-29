//
//  StartingLocationsVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 3/26/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import CoreData

class StartingLocationsVC: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var startingLocations: [Start] = []
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return startingLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        let start = startingLocations[indexPath.row]
        cell.textLabel?.text = start.name

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let start = startingLocations[indexPath.row]
            context.delete(start)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            getData()
        }
    }

    // perform seque to converterViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "startToDestination", sender: self)
        }
    }
    
    func getData() {
        do {
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Start")
            
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Add Predicate
            //let predicate = NSPredicate(format: "item CONTAINS %@", "Chicken")
            //fetchRequest.predicate = predicate
            
            startingLocations = try context.fetch(fetchRequest) as! [Start]
        } catch {
            print("Fetching Failed")
        }
        tableView.reloadData()
    }

    @IBAction func addStartingLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddStarting", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? DestinationsVC {
            viewController.startingLocation = startingLocations[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
