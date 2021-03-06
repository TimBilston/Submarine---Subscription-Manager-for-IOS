//
//  SubscriptionsViewController.swift
//  Submarine
//
//  Created by Nick Exon on 16/4/2022.
//

import UIKit

class SubscriptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener {
    
    
    @IBOutlet weak var monthlyBudgetUsedLabel: UILabel!
    @IBOutlet weak var monthlyBudgetTotal: UILabel!
    @IBOutlet weak var monthlyBudgetProgressBar: UIProgressView!
    
    var listenerType = ListenerType.subscriptions
    var allSubscriptions: [Subscription] = []
    var selectedSubscription : Subscription?
    var monthlyBudget : Double?
    var monthlyBudgetUsed : Double?
    
    func onUserChange(change: DatabaseChange, userProperties: User) {
        //nothing
    }
    func onCategoriesChange(change: DatabaseChange, categories: [SubscriptionCategory]) {
        //nothing
    }
    func onSubscriptionsChange(change: DatabaseChange, subscriptions: [Subscription]) {
        allSubscriptions = subscriptions
        allSubscriptions = allSubscriptions.sorted(by: { $0.getDaysToPayment() < $1.getDaysToPayment()})
        tableView.reloadData()
        setupBudget()
    }
    
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        allSubscriptions = allSubscriptions.sorted(by: { String($0.getDaysToPayment()) > String($1.getDaysToPayment()) })
        setupBudget()
    }
    
    func setupBudget(){ //intialise the budget values and the progress bar
        monthlyBudget = 0
        monthlyBudgetUsed = 0
        for subscription in allSubscriptions {
            monthlyBudget! += subscription.getMonthlyCost()
            monthlyBudgetUsed! += subscription.getCostRemainingThisMonth()
        }
        monthlyBudgetTotal.text = "of " + String(format: "%.2f", monthlyBudget!)
        monthlyBudgetUsedLabel.text = String(format: "%.2f", monthlyBudgetUsed!)
        
        monthlyBudgetProgressBar.progress = Float(monthlyBudgetUsed! / monthlyBudget!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSubscriptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell") as! customSubscriptionTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 4
        // Configure the cell...
        let subscription = allSubscriptions[indexPath.row]
        cell.subName.text = subscription.name
        cell.subPrice.text = "$" + String(format: "%.2f", subscription.price!)
        cell.subLogo.image = cell.subLogo.loadFile(fileName: subscription.id! + ".png")
        cell.startDate.text = String(subscription.getDaysToPayment()) + " day(s)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubscription = allSubscriptions[indexPath.row]
        performSegue(withIdentifier: "showDetailSegue", sender: self)
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
