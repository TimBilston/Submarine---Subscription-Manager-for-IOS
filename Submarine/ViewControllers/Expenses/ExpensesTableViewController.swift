//
//  ExpensesTableViewController.swift
//  Submarine
//
//  Created by Nick Exon on 13/5/2022.
//

import UIKit

class ExpensesTableViewController: UITableViewController {
    
    var allSubscriptions: [Subscription] = []
    var allCategories: [SubscriptionCategory] = []
    var selectedSubscription : Subscription?
    var displayCategories: Bool = true
    weak var delegate: SegueHandler?
    
    var frequency: Int?

    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source
    
    func switchedToCategories(){
        displayCategories = true
        tableView.reloadData()
    }
    func switchedToSubscriptions(){
        displayCategories = false
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (displayCategories){
            return allCategories.count
        }
        else{
            return allSubscriptions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expensesCell") as! ExpensesTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 4
        
        if (displayCategories){
            //get all the categories from firebase in a list
            //loop through all subscriptions and group based on categoryName
            //tableViewController?.allSubscriptions = allSubscriptions
            //tableViewController?.tableView.reloadData()
            let category = allCategories[indexPath.row]
            cell.subName.text = category.name
            if category.totalPrice != nil{
                switch frequency {
                case 0:
                    cell.subPrice.text = "$" + String(format: "%.2f", (category.totalPrice! / 52))
                case 1:
                    cell.subPrice.text = "$" + String(format: "%.2f", (category.totalPrice! / 12))
                default:
                    cell.subPrice.text = "$" + String(format: "%.2f", category.totalPrice!)
                }
            }
            else{
                cell.subPrice.text = "$0.00"
            }
            cell.subLogo?.image = UIImage(systemName: "cube.box.fill")
        }
        else{
            let subscription = allSubscriptions[indexPath.row]
            cell.subName.text = subscription.name
            // TODO - Convert price here to price based on format above
            switch frequency{
            case 0: //weekly
                cell.subPrice.text = "$" + String(format: "%.2f", subscription.getWeeklyCost())
            case 1: // monthly
                cell.subPrice.text = "$" + String(format: "%.2f", subscription.getMonthlyCost())
            case 2: //yearly
                cell.subPrice.text = "$" + String(format: "%.2f", subscription.getYearlyCost())
            default:
                cell.subPrice.text = "$" + String(format: "%.2f", subscription.price!)
            }
        
            
            cell.subLogo.image = cell.subLogo.loadFile(fileName: subscription.id! + ".png")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (displayCategories){
            
        }
        else{
            selectedSubscription = allSubscriptions[indexPath.row]
            delegate?.segueToNext(identifier: "showDetailSegue", sub: selectedSubscription!)
        }
    }
    func getCategoryPrice(reccurenceID: Int) -> Int {
        return 0
        
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
