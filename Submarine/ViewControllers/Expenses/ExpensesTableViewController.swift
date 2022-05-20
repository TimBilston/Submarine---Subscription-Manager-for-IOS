//
//  ExpensesTableViewController.swift
//  Submarine
//
//  Created by Nick Exon on 13/5/2022.
//

import UIKit

class ExpensesTableViewController: UITableViewController {
    
    var allSubscriptions: [Subscription] = []
    var selectedSubscription : Subscription?
    
    weak var delegate: SegueHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allSubscriptions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expensesCell") as! ExpensesTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 4
        // Configure the cell...
        let subscription = allSubscriptions[indexPath.row]
        cell.subName.text = subscription.name
        // TODO - Convert price here to price based on format above
        cell.subPrice.text = "$" + String(format: "%.2f", subscription.price!)
        cell.subLogo.image = cell.subLogo.loadFile(fileName: subscription.id! + ".png")
        //cell.startDate.text = String(subscription.getDaysToPayment()) + " day(s)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubscription = allSubscriptions[indexPath.row]
        delegate?.segueToNext(identifier: "showDetailSegue", sub: selectedSubscription!)
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

}
