//
//  FirebaseController.swift
//  Submarine
//
//  Created by Nick Exon on 17/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    var database: Firestore
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth?
    var usersRef : CollectionReference?
    var subscriptionsRef : CollectionReference?
    var authHandle: AuthStateDidChangeListenerHandle?
    var subscriptions : [Subscription]
    var currentUser : User?
    var uid : String?
    override init(){
        
        database = Firestore.firestore()
        
        authController = Auth.auth()
        usersRef = database.collection("users")
        
        subscriptions = [Subscription]()
        super.init()
        authListener()
    }
    func login(username: String, password: String){
        Task {
            do {
                let authResult = try await authController!.signIn(withEmail: username, password: password)
                print(authResult);
                //if successfully signed in create a user if one doesnt exist
                //authListener() will take over here
            }
            catch {
                print("Authentication failed with error \(String(describing: error))")
            }
        }
    }
    func signUp(username: String, password: String){
        Task {
            do {
                let authResult = try await authController!.createUser(withEmail: username, password: password)
                //display message saying success
                print(authResult)
                // The user was created, so do something!
            }
            catch {
                print("User creation failed with error \(String(describing: error))")
            }
        }
    }
    
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        if listener.listenerType == .subscriptions || listener.listenerType == .all {
            listener.onSubscriptionsChange(change: .update, subscriptions: subscriptions)
        }
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, userProperties: currentUser!)
        }
    }
    
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    func addSubscription(name: String, price : Double, category: SubscriptionCategory, recurrence: Int, startDate: String) -> Subscription{
        let subscription = Subscription()
        subscription.name = name
        subscription.price = price
        subscription.category = category
        subscription.recurrence = recurrence
        subscription.startDate = startDate

        //Once created add to firestore
        do{
            if let subscriptionsRef = try subscriptionsRef?.addDocument(from: subscription) {
                subscription.id = subscriptionsRef.documentID
            }
        } catch{
            print("Failed to serialize Subscription")
        }
        return subscription
    }
    func editSubscription(subscription: Subscription) -> Subscription {

        //Once created add to firestore
        do{
            if (try subscriptionsRef?.document(subscription.id!).setData(from: subscription)) != nil {
                print("successful serialise of subscription")
            }
        } catch{
            print("Failed to serialize Subscription")
        }
        return subscription
    }
    func deleteSubscription(subscription: Subscription) {
        if let subscriptionID = subscription.id{
            subscriptionsRef?.document(subscriptionID).delete()
        }
    }
    func cleanup() {
        
    }
    func getSubscriptionByID(id: String) -> Subscription?{
        for subscription in subscriptions {
            if subscription.id == id{
                return subscription
            }
        }
        return nil
    }
    func setupSubscriptionListener(){
        //subscriptionsRef
        database.collection("users").document(self.uid!).collection("subscriptions").addSnapshotListener(){
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else{
                print("failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseSubscriptionSnapshot(snapshot: querySnapshot)
        }
    }
    func setupUserListener(){
        database.collection("users").document(self.uid!).addSnapshotListener {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("failed to fetch user with error: \(String(describing: error))")
                return
            }
            self.parseUserSnapshot(snapshot: querySnapshot)
            self.setupSubscriptionListener()
        }
    }
    func parseUserSnapshot(snapshot: DocumentSnapshot){
        var parsedUser: User?
        do{
            parsedUser = try snapshot.data(as: User.self)
        }
        catch{
            print("Unable to decode User")
            return
        }
        guard let user = parsedUser else {
            print("Document doesn't exist")
            return
        }
        currentUser = user
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.user ||
                listener.listenerType == ListenerType.all {
                listener.onUserChange(change: DatabaseChange.update, userProperties: currentUser!)
            }
        }
    }
    func parseSubscriptionSnapshot(snapshot: QuerySnapshot){
        snapshot.documentChanges.forEach { (change) in
            var parsedSubscription: Subscription?
            do{
                parsedSubscription = try change.document.data(as: Subscription.self)
            }
            catch{
                print("Unable to decode Subscription")
                return
            }
            guard let subscription = parsedSubscription else {
                print("Document doesn't exist")
                return
            }
            if change.type == .added {
                subscriptions.append(subscription)
            }
            else if change.type == .modified {
                subscriptions[Int(change.oldIndex)] = subscription
            }
            else if change.type == .removed {
                subscriptions.remove(at: Int(change.oldIndex))
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.subscriptions ||
                    listener.listenerType == ListenerType.all {
                    listener.onSubscriptionsChange(change: .update, subscriptions: subscriptions)
                }
            }
        }
    }
    
    func authListener(){
        authHandle = authController!.addStateDidChangeListener { (auth, user) in
            //the auth state has changed
            let user = Auth.auth().currentUser
            if let user = user {
                // The user's ID, unique to the Firebase project.
                let uid = user.uid
                self.uid = uid
                let docRef = self.database.collection("users").document(uid)
                //check if user exists
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        //user document exists -> set current user
                    } else {
                        //user document does not exist -> create and then set current user
                        print("Document does not exist")
                        self.usersRef!.document(uid).setData([
                            "username": "Leon Kennedy",
                            "subscriptions": [Subscription]()
                        ])
                    }
                    self.subscriptionsRef = docRef.collection("subscriptions")
                    self.setupUserListener()
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
    }
}
