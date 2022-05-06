//
//  AddSubscriptionViewController.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit

class AddSubscriptionViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var recurrenceSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func createSubscription(_ sender: Any) {
        guard let name = nameTextField.text, let price = priceTextField.text, let recurrence = Recurrence(rawValue: Int(recurrenceSegmentedControl.selectedSegmentIndex)) else {
            return
        }
        if name.isEmpty || price.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
            if name.isEmpty {
                errorMsg += "- Must provide a name\n" }
            if price.isEmpty {
                errorMsg += "- Must provide price"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
       // getIcon(name: name)
        let _ = databaseController?.addSubscription(name: name, price: Double(price) ?? 0.0, recurrence: recurrence.rawValue)
        navigationController?.popViewController(animated: true)
    }
    
//    func getIcon(name: String) -> Data {
        /*
         Store the image returned from API
        */
        
//        // Obtaining the Location of the Documents Directory
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        // Create URL
//        let url = documents.appendingPathComponent(name + ".png")
//
//        // Convert to Data
//        if let data = image.pngData() {
//            do {
//                try data.write(to: url)
//            } catch {
//                print("Unable to Write Image Data to Disk")
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
