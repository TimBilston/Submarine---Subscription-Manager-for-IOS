//
//  ExpenseDataViewController.swift
//  Submarine
//
//  Created by Nick Exon on 27/5/2022.
//

import UIKit

class ExpenseDataViewController: UIViewController {

    var subscriptionData : Subscription?
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var TextLabelTotalSinceStart: UILabel!
    @IBOutlet weak var totalSinceStartDateLabel: UILabel!
    @IBOutlet weak var costLeftThisYearLabel: UILabel!
    @IBOutlet weak var weeklyCostLabel: UILabel!
    @IBOutlet weak var monthlyCostLabel: UILabel!
    @IBOutlet weak var yearlyCost: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillSubscriptionData()
        // Do any additional setup after loading the view.
    }

    func fillSubscriptionData(){
        /*
         Fill Subscription Data
         */
        guard let subscription = subscriptionData else {
            return
        }
        //set details based on subscription
        title = subscription.name! + " Expense Data"
        iconView.image = iconView.loadFile(fileName: subscription.id! + ".png")
        TextLabelTotalSinceStart.text = "Total since " + subscription.startDate!
        totalSinceStartDateLabel.text = String(format: "%.2f", subscription.getTotalCostSinceStartDate())
        costLeftThisYearLabel.text = String(format: "%.2f", subscription.getCostRemainingThisYear())
        weeklyCostLabel.text = String(format: "%.2f", subscription.getWeeklyCost())
        monthlyCostLabel.text = String(format: "%.2f", subscription.getMonthlyCost())
        yearlyCost.text = String(format: "%.2f", subscription.getYearlyCost())

//        priceField.text = String(format: "%.2f", subscription.price!)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YY/MM/dd"
//        if let startDate = dateFormatter.date(from: subscription.startDate!){
//            firstBillingDate.date = startDate
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
