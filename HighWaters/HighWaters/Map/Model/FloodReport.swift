//
//  FloodReport.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import Foundation
import FirebaseFirestore

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
    
    init?(_ snapshot: QueryDocumentSnapshot)  {
        guard let latitude = snapshot["latitude"] as? Double,
              let longitude = snapshot["longitude"] as? Double else {
            return nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
        self.documentID = snapshot.documentID
    }
    
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [
            "latitude": self.latitude,
            "longitude": self.longitude,
            "reportedDate": self.reportedDate.formatAsString()
        ]
        
        if let documentID = self.documentID {
            dictionary["documentID"] = documentID
        }
        
        return dictionary
    }
}
