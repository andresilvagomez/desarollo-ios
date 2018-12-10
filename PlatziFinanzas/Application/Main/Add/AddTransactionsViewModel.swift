//
//  AddTransactions.swift
//  PlatziFinanzas
//
//  Created by Andres Silva on 12/5/18.
//  Copyright © 2018 Platzi. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AddTransactionsViewModel {
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func add(name: String, description: String, value: String) {
        
    }
}
