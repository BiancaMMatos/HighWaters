//
//  FloodRepository.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import CoreLocation
import FirebaseFirestore


protocol FloodRepository {
    func fetchFloods(completion: @escaping (Result<[FloodReport], Error>) -> Void) throws
    func saveNewFlood(_ report: FloodReport)
}


final class FloodRepositoryImpl: FloodRepository {
    
    var floods: [FloodReport] = [FloodReport]()
    
    private lazy var db: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    
    
    func fetchFloods(completion: @escaping (Result<[FloodReport], any Error>) -> Void) throws {
        self.db.collection("flooded-regions").addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                print("🚨 Error fetch document. Error: \(error?.localizedDescription ?? "not found")")
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
    
    func saveNewFlood(_ report: FloodReport)  {
        var documentRef: DocumentReference? = nil
        
        documentRef = self.db.collection("flooded-regions").addDocument(data: report.toDictionary() as [String : Any]) { error in
            
            if let error {
                
                print("🚨 Error: \(error.localizedDescription)")
                
                if let firestoreError = error as? FirestoreErrorCode {
                    switch firestoreError.code {
                    case .aborted:
                        print("⚠️ Error: Aborted action, \(firestoreError.localizedDescription). Code: \(firestoreError.errorCode)")
                    case .alreadyExists:
                        print("⚠️ Error: Already exists, \(firestoreError.localizedDescription). Code: \(firestoreError.errorCode)")
                    case .dataLoss:
                        print("⚠️ Error: Losted data, \(firestoreError.localizedDescription). Code: \(firestoreError.errorCode)")
                    default:
                        print("⚠️ Error: \(firestoreError.errorCode)")
                    }
                    
                    
                    
                } else if let documentID = documentRef?.documentID {
                    var updatedReport = report
                    updatedReport.documentID = documentID
                }
            }
        }
        
    }
    
    private func updateAnnotations() {
        DispatchQueue.main.async {
            self.floods.forEach {
                self.saveNewFlood($0)
            }
        }
    }
}
