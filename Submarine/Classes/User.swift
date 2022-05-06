//
//  User.swift
//  Submarine
//
//  Created by Nick Exon on 29/4/2022.
//

import UIKit
import FirebaseFirestoreSwift

class User: NSObject, Codable{
    @DocumentID var id: String?
    var username : String
    var subscriptionList : [Subscription] = []
    //var databaseController : FirebaseController?
    
    init(id : String, username : String, subscriptionList : [Subscription]) {
        self.id = id
        self.username = username
        self.subscriptionList = subscriptionList
    }
//    func getSubscriptions() -> [Subscription]{
//        //return list of subscriptions from FirebaseController
//        return [subscriptionList]
//    }
}
