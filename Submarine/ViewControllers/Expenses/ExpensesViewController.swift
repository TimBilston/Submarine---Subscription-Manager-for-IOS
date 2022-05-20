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
    var listenerType = ListenerType.subscriptions
    var allSubscriptions: [Subscription] = []
    var tableViewController: ExpensesTableViewController?
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        tableViewController = self.children.first as? ExpensesTableViewController
        tableViewController?.allSubscriptions = allSubscriptions
        tableViewController?.tableView.reloadData()
        tableViewController?.delegate = self
        // Do any additional setup after loading the view.
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
        //die
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
