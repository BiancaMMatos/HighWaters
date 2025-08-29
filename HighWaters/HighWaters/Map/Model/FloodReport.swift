//
//  FloodReport.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import Foundation

struct FloodReport: Codable {
    var documentID: String?
    let latitude: Double
    let longitude: Double
    var reportedDate: Date = Date()
}


extension FloodReport {
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    func toDictionary() -> [String : Any?] {
        return [
            "documentID": self.documentID ?? nil,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "reportedDate": self.reportedDate.formatAsString()
        ]
    }
}
