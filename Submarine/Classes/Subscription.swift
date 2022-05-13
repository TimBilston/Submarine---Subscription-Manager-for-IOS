//
//  Subscription.swift
//  Submarine
//
//  Created by Nick Exon on 16/4/2022.
//

import UIKit
import FirebaseFirestoreSwift

enum Recurrence: Int{
    case weekly = 0
    case monthly = 1
    case yearly = 3
}

class Subscription: NSObject, Codable{
    
    @DocumentID var id: String?
    var name: String?
    var price: Double?
    var recurrence: Int?
    var imageRef: String?
    var colour: UIColor?
    var startDate: String?
        
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case recurrence
        case startDate
    }
    func getDaysToPayment() -> Int{
        //convert string date to date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        guard let startDate = startDate else {
            return 0
        }
        guard let startDate = dateFormatter.date(from: startDate) else{
            return 0
        }
        switch(recurrence){
        case 0: //weekly
            //gets the day of week as 1-7. 1 = Sunday, 7 = Sat
            let recurrenceDay = Calendar.current.dateComponents([.weekday], from: startDate).weekday!
            let currentDate = Date()
            var dueDate : Date?
            let currentDay = Calendar.current.dateComponents([.weekday], from: currentDate).weekday!
            
            var dateComponent = DateComponents()
            
            if currentDay > recurrenceDay { //recurrence day is before currentDay
                let diff = currentDay - recurrenceDay
                dateComponent.day = diff
                dueDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
                dateComponent.day = 7 //
                dueDate = Calendar.current.date(byAdding: dateComponent, to: dueDate!) //will = next due date
            }
            
            else if currentDay == recurrenceDay && currentDate < startDate {
                return 0 //recurring today
            }
            else{ //recurrenceDay is after currentDay
                let diff = recurrenceDay - currentDay
                dateComponent.day = diff
                dueDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
            }
            
            //return the difference in days between current and due
            let calendar = Calendar.current
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: currentDate)
            let date2 = calendar.startOfDay(for: dueDate!)

            let components = calendar.dateComponents([.day], from: date1, to: date2)
            return components.day!

        case 1: //monthly
            return 0
        case 3: //yearly
            return 0
        default: //wrong fuken thing
            return 0
        }
    }
}

extension Subscription{
    var subcriptionRecurrence: Recurrence {
        get{
            return Recurrence(rawValue: self.recurrence!)!
        }
        set{
            self.recurrence = newValue.rawValue
        }
    }
}
