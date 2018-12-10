//
//  Numeric.swift
//  PlatziFinanzas
//
//  Created by Andres Silva on 12/10/18.
//  Copyright © 2018 Platzi. All rights reserved.
//

import Foundation

extension Numeric {
    func currency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let formatted = formatter.string(from: self as! NSNumber) else {
            return "\(self)"
        }
        
        return formatted
    }
}

