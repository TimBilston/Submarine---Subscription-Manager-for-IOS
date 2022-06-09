//
//  DetailSubscriptionViewController.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit

class DetailSubscriptionViewController: UIViewController, sendIconProtocol, sendCategoryProtocol, sendAlertProtocol {
    
    func sendAlert(daysBefore: Int) {
        self.alert = daysBefore
        switch(daysBefore){
        case 0:
            self.alertLabel.text = "None"
        case 1:
            self.alertLabel.text = "Same day"
        case 2:
            self.alertLabel.text = "1 Day before"
        case 3:
            self.alertLabel.text = "2 Days before"
        case 4:
            self.alertLabel.text = "1 Week before"
        default:
            self.alertLabel.text = "Error"
        }
    }
    
    func sendCategory(category: SubscriptionCategory) {
        self.categoryLabel.text = category.name
    }
    func sendIconBack(icon: UIImage) {
        self.subLogo.image = icon
        smallIcon.image = icon
    }
    
    weak var databaseController: DatabaseProtocol?
    var subscriptionData: Subscription?
    var alert: Int?
    
    @IBOutlet weak var subLogo: UIImageView!
    @IBOutlet weak var smallIcon: UIImageView!
    @IBOutlet weak var paymentDueLabel: UILabel!
    @IBOutlet weak var firstBillingDate: UIDatePicker!
    @IBOutlet weak var recurrenceControl: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        fillSubscriptionData()
    }
    
    func fillSubscriptionData(){
        /*
         Fill Subscription Data
         */
        guard let subscription = subscriptionData else {
            return
        }
        //set details based on subscription
        title = subscription.name
        subLogo.image = subLogo.loadFile(fileName: subscription.id! + ".png")
        smallIcon.image = subLogo.loadFile(fileName: subscription.id! + ".png")
        paymentDueLabel.text = "Payment of $" + String(format: "%.2f", subscription.price!) + " due in " + String(subscription.getDaysToPayment()) + " day(s)"
        nameField.text = subscription.name
        priceField.text = String(format: "%.2f", subscription.price!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        if let startDate = dateFormatter.date(from: subscription.startDate!){
            firstBillingDate.date = startDate
        }
        recurrenceControl.selectedSegmentIndex = subscription.recurrence!
        categoryLabel.text = subscription.categoryName
        sendAlert(daysBefore: subscription.alert!)
    }
    @IBAction func viewExpenseData(_ sender: Any) {
    }
    @IBAction func deleteSubscription(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Subscription", message: "Are you sure you want to delete this subscription \n this action cannot be undone", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in
            print("Cancel Pressed")
            return
            
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(_) in
            print("Delete Pressed")
            guard let subscriptionData = self.subscriptionData else {
                return
            }
            self.databaseController?.deleteSubscription(subscription: subscriptionData)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveSubscription(_ sender: Any) {
        guard let name = nameField.text, let price = priceField.text, let recurrence = Recurrence(rawValue: Int(recurrenceControl.selectedSegmentIndex)), let category = categoryLabel.text, let startDate = firstBillingDate else {
            return
        }
        if name.isEmpty || price.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
            if name.isEmpty {
                errorMsg += "- Must provide a name\n" }
            if price.isEmpty {
                errorMsg += "- Must provide price"
            }
            if subLogo.image == nil{
                errorMsg += "- Must provide Icon"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        
        let dateFormatter = DateFormatter()    // Create Date Formatter
        dateFormatter.dateFormat = "YY/MM/dd" // Set Date Format
        let startDateString  = dateFormatter.string(from: startDate.date)  // Convert Date to String
    
        guard let subscriptionData = subscriptionData else {
            return
        }
        subscriptionData.name = name
        subscriptionData.price = Double(price) ?? 0.0
        subscriptionData.recurrence = recurrence.rawValue
        subscriptionData.startDate = startDateString
        subscriptionData.categoryName = category
        subscriptionData.alert = alert
        let sub = databaseController?.editSubscription(subscription: subscriptionData)
        guard let image = subLogo.image else {return}
        subLogo.savePng(image, id: (sub?.id)!) //saves the image with the Firebase ID
        sub?.setupNotification(timing: alert!)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "changeIconSegue"{
            let destination = segue.destination as! IconAPIViewController
            destination.delegate = self
        }
        if segue.identifier == "changeCategorySegue"{
            let destination = segue.destination as! CategoryChangeTableViewController
            destination.delegate = self
        }
        if segue.identifier == "showExpenseDataSegue"{
            let destination = segue.destination as! ExpenseDataViewController
            destination.subscriptionData = subscriptionData
        }
        if segue.identifier == "changeAlertSegue"{
            let destination = segue.destination as! AlertChangeTableViewController
            destination.delegate = self
        }
    }
}
