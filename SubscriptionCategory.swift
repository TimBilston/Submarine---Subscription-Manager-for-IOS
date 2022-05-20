//
//  SubscriptionCategory.swift
//  Submarine
//
//  Created by Nick Exon on 20/5/2022.
//

import UIKit
import FirebaseFirestoreSwift

class SubscriptionCategory: NSObject {
    @DocumentID var id: String?
    var category: String?
    
}
