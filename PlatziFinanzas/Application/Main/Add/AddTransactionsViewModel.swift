//
//  AddTransactions.swift
//  PlatziFinanzas
//
//  Created by Andres Silva on 12/5/18.
//  Copyright © 2018 Platzi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PlatziFinanzasCore

class AddTransactionsViewModel {
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func add(name: String, description: String, value: String) {
        guard let value = Float(value) else {
            return
        }
        
        let transaction = PlatziFinanzasCore.Transaction(
            value: value,
            category: .expend,
            name: name,
            date: Date()
        )
        
        guard let data = transaction.data() else {
            return
        }
        
        db.collection("transactions").addDocument(data: data)
    }
}
