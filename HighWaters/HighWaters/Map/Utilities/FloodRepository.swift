//
//  FloodRepository.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import CoreLocation
import FirebaseFirestore


protocol FloodRepository {
    var floods: [FloodReport] { get set }
    func saveFlood(_ report: FloodReport)
    func configureObserves()
}


final class FloodRepositoryImpl: FloodRepository {
    var floods: [FloodReport] = [FloodReport]()
    
    private lazy var db: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    
    
    func saveFlood(_ report: FloodReport) {
        
        var documentRef: DocumentReference? = nil
        
        documentRef = self.db.collection("flooded-regions").addDocument(data: report.toDictionary() as [String : Any]) { error in
            
            if let error {
                print("Error: \(error)")
                
            } else if let documentID = documentRef?.documentID {
                var updatedReport = report
                updatedReport.documentID = documentID
            }
        }
    }
    
    private func updateAnnotations() {
        DispatchQueue.main.async {
            self.floods.forEach {
                self.saveFlood($0)
            }
        }
    }
    
    func configureObserves() {
        self.db.collection("flooded-regions").addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                print("Error fetch document. Error: \(error?.localizedDescription ?? "not found")")
                return
            }
            
            snapshot.documentChanges.forEach { [weak self] diff in
                
                if diff.type == .added {
                    if let flood = FloodReport(diff.document) {
                        self?.floods.append(flood)
                        self?.updateAnnotations()
                    }
                    
                    
                } else if diff.type == .removed {
                    if let flood = FloodReport(diff.document) {
                        if let floods = self?.floods {
                            self?.floods = floods.filter({ $0.documentID != flood.documentID })
                        }
                        self?.updateAnnotations()
                    }
                }
            }
        }
        
    }
    
    
    
}
