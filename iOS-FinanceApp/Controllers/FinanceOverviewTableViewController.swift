//
//  FinanceOverviewTableViewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 19.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class FinanceOverviewTableViewController: UITableViewController {
    
    var tableEntries: Results<Entry>!
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        tableView.dataSource = realm
        tableView.delegate = self   

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
=======
        tableEntries = realm.objects(Entry.self)
        tableView.delegate = self
        tableView.dataSource = self
>>>>>>> 677958a... TableViewController blueprint
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as? FinanceOverviewCell
        let entryData = tableEntries[indexPath.row]
        cell?.entryAmountLabel.text = String(entryData.amount)
        cell?.entryNameLabel.text = entryData.name
        
        return cell!
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class FinanceOverviewCell: UITableViewCell {
    @IBOutlet weak var entryAmountLabel: UILabel!
    @IBOutlet weak var entryNameLabel: UILabel!
}
