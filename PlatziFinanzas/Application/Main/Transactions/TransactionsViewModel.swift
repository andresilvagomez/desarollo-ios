//
//  TransactionsViewModel.swift
//  PlatziFinanzas
//
//  Created by Andres Silva on 12/10/18.
//  Copyright © 2018 Platzi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PlatziFinanzasCore

class TransactionsViewModel {
    private var items: [PlatziFinanzasCore.Transaction] = []
    
    private var db: Firestore {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = true
        db.settings = settings
        return db
    }
    
    var numberOfitems: Int {
        return items.count
    }
    
    init() {
        db.collection("trasactions").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.items.removeAll()
            
            try? snapshot?.documents.forEach({ (snapshot) in
                let json = snapshot.data()
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                
                guard let transaction = try? JSONDecoder().decode(Transaction.self, from: jsonData) else {
                    return
                }
                
                self.items.append(transaction)
            })
        }
    }
}
