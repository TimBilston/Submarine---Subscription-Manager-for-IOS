//
//  DatabaseProtocol.swift
//
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case user
    case subscriptions
    case auth
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange, userProperties: User)
    func onSubscriptionsChange(change: DatabaseChange, subscriptions: [Subscription])
}

protocol DatabaseProtocol: AnyObject {
            
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addSubscription(name: String, price : Double, recurrence: Int, startDate: String) -> Subscription
    func deleteSubscription(subscription: Subscription)
    
}
