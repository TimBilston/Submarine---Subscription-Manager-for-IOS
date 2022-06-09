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
    case categories
    case auth
    case all
    case subCat
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange, userProperties: User)
    func onSubscriptionsChange(change: DatabaseChange, subscriptions: [Subscription])
    func onCategoriesChange(change: DatabaseChange, categories: [SubscriptionCategory])
}

protocol DatabaseProtocol: AnyObject {
            
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addSubscription(name: String, price : Double, category: String, recurrence: Int, startDate: String, alert: Int) -> Subscription
    func editSubscription(subscription: Subscription) -> Subscription
    func deleteSubscription(subscription: Subscription)
    
}
