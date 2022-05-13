//
//  AddSubscriptionViewController.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit

class AddSubscriptionViewController: UIViewController, sendIconProtocol {
    func sendIconBack(icon: UIImage) {
        self.imageView.image = icon
    }
    
    weak var databaseController: DatabaseProtocol?
    var icon: UIImage?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var recurrenceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        startDatePicker.maximumDate = Date.now
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        loadIcon()
    }
    
    @IBAction func createSubscription(_ sender: Any) {
        guard let name = nameTextField.text, let price = priceTextField.text, let recurrence = Recurrence(rawValue: Int(recurrenceSegmentedControl.selectedSegmentIndex)), let startDate = startDatePicker else {
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
        
        let sub = databaseController?.addSubscription(name: name, price: Double(price) ?? 0.0, recurrence: recurrence.rawValue, startDate: startDateString)
        guard let image = imageView.image else {return}
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
    }
    

}
