//
//  Date+Extensions.swift
//  HighWaters
//
//  Created by Bianca Maciel on 28/08/25.
//

import Foundation


extension Date {
    
    func formatAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
    
}
