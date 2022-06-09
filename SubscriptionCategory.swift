//
//  SubscriptionCategory.swift
//  Submarine
//
//  Created by Nick Exon on 20/5/2022.
//

import UIKit
import FirebaseFirestoreSwift

class SubscriptionCategory: NSObject, Codable{
    @DocumentID var id: String?
    var name: String?
    var totalPrice: Double?
    override init() {
        totalPrice = 0
    }
    func addtoPrice(price: Double){
        if totalPrice == nil{
            totalPrice = 0
        }
        totalPrice! += price
    }
}
