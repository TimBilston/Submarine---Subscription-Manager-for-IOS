//
//  AddSubscriptionViewController.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit

class AddSubscriptionViewController: UIViewController, sendIconProtocol, sendCategoryProtocol, sendAlertProtocol{
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
    func sendIconBack(icon: UIImage) {
        self.imageView.image = icon
    }
    func sendCategory(category: SubscriptionCategory) {
        self.categoryLabel.text = category.name
    }
    weak var databaseController: DatabaseProtocol?
    var icon: UIImage?
    var alert: Int = 0
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var recurrenceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    var category: SubscriptionCategory?
    
    @IBAction func changeCategory(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = 0
        startDatePicker.maximumDate = Date.now
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        loadIcon()
    }
    
    @IBAction func createSubscription(_ sender: Any) {
        guard let name = nameTextField.text, let price = priceTextField.text, let category = categoryLabel.text, let recurrence = Recurrence(rawValue: Int(recurrenceSegmentedControl.selectedSegmentIndex)), let startDate = startDatePicker else {
            return
        }
        if name.isEmpty || price.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
            if name.isEmpty {
                errorMsg += "- Must provide a name\n" }
            if price.isEmpty {
                errorMsg += "- Must provide price"
            }
            if imageView.image == nil{
                errorMsg += "- Must provide Icon"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
       
        let dateFormatter = DateFormatter()    // Create Date Formatter
        dateFormatter.dateFormat = "YY/MM/dd" // Set Date Format
        let startDateString  = dateFormatter.string(from: startDate.date)  // Convert Date to String
        
        let sub = databaseController?.addSubscription(name: name, price: Double(price) ?? 0.0, category: category, recurrence: recurrence.rawValue, startDate: startDateString, alert: alert)
        guard let image = imageView.image else {return}
        
        sub?.setupNotification(timing: alert)
        
        imageView.savePng(image, id: (sub?.id)!) //saves the image with the Firebase ID
        navigationController?.popViewController(animated: true)
    }
    func loadIcon(){
        //1231231
        //let image = imageView.loadFile(fileName: "1231231.jpg")
        if icon != nil {
            imageView.image = icon
        }
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
        if segue.identifier == "changeAlertSegue"{
            let destination = segue.destination as! AlertChangeTableViewController
            destination.delegate = self
        }
    }
    

}
