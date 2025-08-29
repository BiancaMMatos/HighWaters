//
//  FloodRepository.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import CoreLocation
import FirebaseFirestore


protocol FloodRepository {
    func saveFlood(_ report: FloodReport)
}


final class FloodRepositoryImpl: FloodRepository {
    
    private lazy var db: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    
    
    func saveFlood(_ report: FloodReport) {
        
        var documentRef: DocumentReference? = nil
        
        documentRef = self.db.collection("flooded-regions").addDocument(data: report.toDictionary()) { error in
            
            if let error {
                print("Error: \(error)")
                
            } else if let documentID = documentRef?.documentID {
                var updatedReport = report
                updatedReport.documentID = documentID
            }
        }
    }
    
    
}
