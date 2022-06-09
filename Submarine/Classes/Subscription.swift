//
//  Subscription.swift
//  Submarine
//
//  Created by Nick Exon on 16/4/2022.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase
import UserNotifications

enum Recurrence: Int{
    case weekly = 0
    case monthly = 1
    case yearly = 2
}

class Subscription: NSObject, Codable{
    
    @DocumentID var id: String?
    var name: String?
    var price: Double?
    var recurrence: Int?
    var imageRef: String?
    var startDate: String?
    var categoryName: String?
    var alert: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case recurrence
        case startDate
        case categoryName
        case alert
    }
    func setupNotification(timing: Int){
        if timing == 0 {
            //nothing
        }
        else{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
            { (granted, error) in
                if !granted {
                    print("Permission was not granted!")
                    return
                }
            }
            // Create a notification content object
            let notificationContent = UNMutableNotificationContent()
            // Create its details
            notificationContent.title = "Subscription Almost Due!"
            notificationContent.subtitle = self.name!
            let price = String(format: "%.2f", self.price!)
            // Configure the recurring date.
            
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = 9
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            let startDate = dateFormatter.date(from: startDate!)
            let startDay = Calendar.current.dateComponents([.weekday], from: startDate!)
            let startWeekOfYear = Calendar.current.dateComponents([.weekOfYear], from: startDate!)
            let startWeekOfMonth = Calendar.current.dateComponents([.weekOfMonth], from: startDate!)
            let startMonth = Calendar.current.dateComponents([.month], from: startDate!)
            //let startWeek = Calendar.current.dateComponents([.weekday], from: startDate!)

            switch(recurrence){
            case 0: //weekly
                switch(timing){
                case 1:
                    notificationContent.body = price + "Due Today"
                    dateComponents.weekday = startDay.weekday!
                case 2:
                    notificationContent.body = price + "Due Tomorrow"
                    dateComponents.weekday = startDay.weekday! + 1
                case 3:
                    notificationContent.body = price + "Due in 2 days"
                    dateComponents.weekday = startDay.weekday! + 2
                default:
                    break;
                }
            case 1: //monthly
                switch(timing){
                case 1:
                    notificationContent.body = price + "Due Today"
                    dateComponents.weekday = startDay.weekday!
                    dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth
                case 2:
                    notificationContent.body = price + "Due Tomorrow"
                    dateComponents.weekday = startDay.weekday! + 1
                    dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth
                case 3:
                    notificationContent.body = price + "Due in 2 days"
                    dateComponents.weekday = startDay.weekday! + 2
                    dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth
                case 4:
                    notificationContent.body = price + "Due in 1 week"
                    dateComponents.weekday = startDay.weekday
                    if(startWeekOfMonth.weekOfMonth == 1){
                        dateComponents.weekOfMonth = 4
                    }
                    else{
                        dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth! - 1
                    }
                    break;
                default:
                    break;
                }
            case 2: //yearly
                switch(timing){
                case 1:
                    notificationContent.body = price + "Due Today"
                    dateComponents.weekday = startDay.weekday!
                    dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth
                    dateComponents.month = startMonth.month
                case 2:
                    notificationContent.body = price + "Due Tomorrow"
                    dateComponents.weekday = startDay.weekday! + 1
                    dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth
                    dateComponents.month = startMonth.month
                case 3:
                    notificationContent.body = price + "Due in 2 days"
                    dateComponents.weekday = startDay.weekday! + 2
                    dateComponents.weekOfMonth = startWeekOfMonth.weekOfMonth
                    dateComponents.month = startMonth.month
                case 4:
                    notificationContent.body = price + "Due in 1 week"
                    dateComponents.weekday = startDay.weekday
                    dateComponents.weekOfYear = startWeekOfYear.weekOfYear! - 1
                    break;
                default:
                    break;
                }
                
            default:
                break;
            }
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: true)
            // Create our request
            // Provide a unique identifier (subscription id), our content and the trigger
            let request = UNNotificationRequest(identifier: self.id!,
             content: notificationContent, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
               }
            }
        }
    }
    func getDaysToPayment() -> Int{
        //convert string date to date object
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        dateFormatter.dateFormat = "YY/MM/dd"
        guard let startDate = startDate else {
            return 0
        }
        guard let startDate = dateFormatter.date(from: startDate) else{
            return 0
        }
        let currentDate = Date()
        switch(recurrence){
        case 0: //weekly
            //gets the day of week as 1-7. 1 = Sunday, 7 = Sat
            let recurrenceDay = calendar.dateComponents([.weekday], from: startDate).weekday!
            var dueDate : Date?
            let currentDay = calendar.dateComponents([.weekday], from: currentDate).weekday!
            
            var dateComponent = DateComponents()
            
            if currentDay > recurrenceDay { //recurrence day is before currentDay
                let diff = 7 - (currentDay - recurrenceDay)
                dateComponent.day = diff
                dueDate = calendar.date(byAdding: dateComponent, to: currentDate)!
                //dateComponent.day = 7 //
                //dueDate = Calendar.current.date(byAdding: dateComponent, to: dueDate!) //will = next due date
            }
            
            else if currentDay == recurrenceDay && currentDate < startDate {
                return 0 //recurring today
            }
            else{ //recurrenceDay is after currentDay
                let diff = recurrenceDay - currentDay
                dateComponent.day = diff
                dueDate = calendar.date(byAdding: dateComponent, to: currentDate)!
            }
            
            //return the difference in days between current and due
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: currentDate)
            let date2 = calendar.startOfDay(for: dueDate!)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            return components.day!
            
        case 1: //monthly
            let recurrenceDay = calendar.dateComponents([.weekday], from: startDate).weekday!
            let recurrenceWeekOfMonth = calendar.dateComponents([.weekOfMonth], from: startDate).weekOfMonth!
            
            let currentDay = calendar.dateComponents([.weekday], from: currentDate).weekday!
            let currentWeekOfMonth = calendar.dateComponents([.weekOfMonth], from: currentDate).weekOfMonth!
            let currentMonth = calendar.dateComponents([.month], from: currentDate).month!
            let currentYear = calendar.dateComponents([.year], from: currentDate).year!
            var dueDate : Date?
            
            var dueDateComponents = DateComponents()
            dueDateComponents.weekday = recurrenceDay
            dueDateComponents.weekOfMonth = recurrenceWeekOfMonth
            dueDateComponents.year = currentYear
            if currentWeekOfMonth > recurrenceWeekOfMonth{
                dueDateComponents.month = currentMonth + 1
            }
            else if currentWeekOfMonth == recurrenceWeekOfMonth{
                if currentDay > recurrenceDay{
                    dueDateComponents.month = currentMonth + 1
                }
                else{
                    dueDateComponents.month = currentMonth
                }
            }
            else {
                dueDateComponents.month = currentMonth
            }
            dueDate = calendar.date(from: dueDateComponents)
            
            let date1 = calendar.startOfDay(for: currentDate)
            let date2 = calendar.startOfDay(for: dueDate!)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            return components.day!
        case 2: //yearly
            let recurrenceDay = calendar.ordinality(of: .day, in: .year, for: startDate)
            let currentDay = calendar.ordinality(of: .day, in: .year, for: currentDate)
            let currentYear = calendar.dateComponents([.year], from: currentDate).year!

            var dueDate : Date?
            var dueDateComponents = DateComponents()
            dueDateComponents.day = recurrenceDay
            
            if currentDay! > recurrenceDay!{
                dueDateComponents.year = currentYear + 1
            }
            else{
                dueDateComponents.year = currentYear
            }
            dueDate = calendar.date(from: dueDateComponents)
            
            let date1 = calendar.startOfDay(for: currentDate)
            let date2 = calendar.startOfDay(for: dueDate!)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            return components.day!
            
        default: //wrong fuken thing
            return 0
        }
    }
    func getCostRemainingThisMonth() -> Double{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        guard let startDate = startDate else {
            return 0
        }
        guard let startDate = dateFormatter.date(from: startDate) else{
            return 0
        }
        let currentDate = Date()
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date().endOfMonth)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date2, to: date1)
        let daysLeftInMonth = components.day!
        let daysToPayment = getDaysToPayment()
        
        switch(recurrence){
        case 0: //weekly
            let reccurenceWeekdaysInMonth = calendar.dateComponents([.weekOfYear], from: currentDate, to: date1).weekOfYear
            
            let currentWeekday = calendar.dateComponents([.weekday], from: currentDate).weekday!
            let recurrenceWeekday = calendar.dateComponents([.weekday], from: startDate).weekday!

            if currentWeekday > recurrenceWeekday {
                return Double(reccurenceWeekdaysInMonth!) * self.price!
            }
            else{
                return Double(reccurenceWeekdaysInMonth! + 1) * self.price!
            }
            
        case 1: // monthly
            if daysToPayment > daysLeftInMonth{
                return 0.00
            }
            else{
                return self.price!
            }
        case 2: //yearly
            let startMonth = calendar.dateComponents([.month], from: startDate).month!
            let currentMonth = calendar.dateComponents([.month], from: currentDate).month!
            
            if startMonth > currentMonth {
                return self.price!
            }
            else if startMonth < currentMonth{
                return 0.00
            }
            else{ //they are equal
                let reccurenceDateDay = Calendar.current.dateComponents([.day], from: startDate).day!
                let currentDateDay = Calendar.current.dateComponents([.day], from: currentDate).day!
                
                if currentDateDay > reccurenceDateDay{
                    return 0.00
                }
                else{
                    return self.price!
                }
            }
        default:
            return 0.00
        }
        
    }
    func getCostRemainingThisYear() -> Double{
        //calculate remaining cost for time period passed in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        guard let startDate = startDate else {
            return 0
        }
        guard let startDate = dateFormatter.date(from: startDate) else{
            return 0
        }
        let currentDate = Date()
        switch(recurrence){
        case 0:
            //how many weeks are left in year
            let weeksLeftInYear = 52 - (Calendar.current.dateComponents([.weekOfYear], from: currentDate).weekOfYear!)
            
            //compare day of week
            let recurrenceDay = Calendar.current.dateComponents([.weekday], from: startDate).weekday!
            let currentDay = Calendar.current.dateComponents([.weekday], from: currentDate).weekday!
            
            if currentDay > recurrenceDay { //recurrence day is before currentDay. Cost has already been paid this week
                return (Double(weeksLeftInYear) - 1) * self.price!
            }
            else{ //recurrenceDay is after currentDay or = currentDay. Cost still to pay this week
                return Double(weeksLeftInYear) * self.price!
            }
        case 1:
            let monthsLeftInYear = 12 - (Calendar.current.dateComponents([.month], from: currentDate).month!)
            
            let reccurenceDateDay = Calendar.current.dateComponents([.day], from: startDate).day!
            let currentDateDay = Calendar.current.dateComponents([.day], from: currentDate).day!
            
            if currentDateDay > reccurenceDateDay { // reccurence day is already passed. already paid this month
                return (Double(monthsLeftInYear) - 1) * self.price!
            }
            else{
                return Double(monthsLeftInYear) * self.price!
            }
        case 2:
            let currentDayInYear  = Calendar.current.ordinality(of: .day, in: .year, for: currentDate)
            let recurrenceDayInYear  = Calendar.current.ordinality(of: .day, in: .year, for: currentDate)
            
            if currentDayInYear! > recurrenceDayInYear!{ //date has already passed this year
                return 0.00
            }
            else{
                return self.price!
            }
        default:
            break;
        }
        return 0.00
    }
    func getTotalCostSinceStartDate() -> Double{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        guard let startDate = startDate else {
            return 0
        }
        guard let startDate = dateFormatter.date(from: startDate) else{
            return 0
        }
        let currentDate = Date()
        switch(recurrence){
        case 0: //weekly
            let theComponents = Calendar.current.dateComponents([.weekOfYear], from: startDate, to: currentDate)
            let theNumberOfWeeks = theComponents.weekOfYear!
            return self.price! * Double(theNumberOfWeeks)
        case 1: //monthly
            let theComponents = Calendar.current.dateComponents([.month], from: startDate, to: currentDate)
            let theNumberOfMonths = theComponents.month!
            return self.price! * Double(theNumberOfMonths)
        case 2: //yearly
            let theComponents = Calendar.current.dateComponents([.year], from: startDate, to: currentDate)
            let theNumberOfYears = theComponents.year!
            return self.price! * Double(theNumberOfYears)
        default:
            break;
        }
        return 0.00
    }
    func getWeeklyCost() -> Double {
        switch(recurrence){
        case 0:
            return self.price!
        case 1:
            return self.price! * 12 / 52
        case 2:
            return self.price! / 52
        default:
            return 0.00
        }
    }
    func getMonthlyCost() -> Double {
        switch(recurrence){
        case 0:
            return self.price! * 52 / 12
        case 1:
            return self.price!
        case 2:
            return self.price! / 12
        default:
            return 0.00
        }
    }
    func getYearlyCost() -> Double {
        switch(recurrence){
        case 0:
            return self.price! * 52
        case 1:
            return self.price! * 12
        case 2:
            return self.price!
        default:
            return 0.00
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
