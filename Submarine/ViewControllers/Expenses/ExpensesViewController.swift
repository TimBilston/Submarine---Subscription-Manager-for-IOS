//
//  ExpensesViewController.swift
//  Submarine
//
//  Created by Nick Exon on 13/5/2022.
//

import UIKit

protocol SegueHandler: AnyObject {
    func segueToNext(identifier: String, sub: Subscription)
}

class ExpensesViewController: UIViewController, DatabaseListener, SegueHandler{
    func segueToNext(identifier: String, sub: Subscription) {
        self.selectedSubscription = sub
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    var selectedSubscription: Subscription?
    var listenerType = ListenerType.subCat
    var allSubscriptions: [Subscription] = []
    var categoryList: [SubscriptionCategory] = []
    
    var tableViewController: ExpensesTableViewController?
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var monthlyExpensesView: UIView!
    @IBOutlet weak var categorySwitch: UISwitch!
    @IBAction func switchValueChanged(_ sender: Any) {
        guard let tbVC = tableViewController else{
            return
        }
        if (categorySwitch.isOn){
            tbVC.switchedToCategories()
        }
        else{
            tbVC.switchedToSubscriptions()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyExpensesView.layer.cornerRadius = 5
        monthlyExpensesView.layer.masksToBounds = true;
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        tableViewController = self.children.first as? ExpensesTableViewController
        tableViewController?.allSubscriptions = allSubscriptions
        tableViewController?.allCategories = categoryList
        tableViewController?.frequency = frequencySegmentedControl.selectedSegmentIndex
        tableViewController?.tableView.reloadData()
        tableViewController?.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var totalFrequencyLabel: UILabel!
    @IBOutlet weak var totalCostFrequency: UILabel!
    @IBOutlet weak var frequencySegmentedControl: UISegmentedControl!
    @IBAction func frequencyChanged(_ sender: Any) {
        guard let tbVC = tableViewController else{
            return
        }
        var cost = 0.00;
        switch frequencySegmentedControl.selectedSegmentIndex{
        case 0: //weekly
            totalFrequencyLabel.text = "Total Weekly Cost"
            for subscription in allSubscriptions {
                cost += subscription.getWeeklyCost()
            }
        case 1: //weekly
            totalFrequencyLabel.text = "Total Monthly Cost"
            for subscription in allSubscriptions {
                cost += subscription.getMonthlyCost()
            }
        case 2: //weekly
            totalFrequencyLabel.text = "Total Yearly Cost"
            for subscription in allSubscriptions {
                cost += subscription.getYearlyCost()
            }
        default:
            break
        }
        totalCostFrequency.text = "$" + String(format: "%.2f", cost)
        
        tbVC.frequency = frequencySegmentedControl.selectedSegmentIndex
        tbVC.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    func onUserChange(change: DatabaseChange, userProperties: User) {
        //nothing
    }
    func onCategoriesChange(change: DatabaseChange, categories: [SubscriptionCategory]) {
        categoryList = categories
        guard let tbVC = tableViewController else{
            return
        }
        tbVC.allCategories = categoryList
        tbVC.tableView.reloadData()
    }

    func onSubscriptionsChange(change: DatabaseChange, subscriptions: [Subscription]) {
        allSubscriptions = subscriptions
        guard let tbVC = tableViewController else{
            return
        }
        tbVC.allSubscriptions = allSubscriptions
        tbVC.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailSegue"{
            let destination = segue.destination as! DetailSubscriptionViewController
            destination.subscriptionData = selectedSubscription
        }
    }
    
}
