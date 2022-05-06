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
        
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case recurrence
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
