//
//  FloodRepository.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import CoreLocation
import FirebaseFirestore


protocol FloodRepository {
    func deleteFlood(_ report: FloodReport)
    func saveNewFlood(_ report: FloodReport)
    func observeFloods(update: @escaping (Result<[FloodReport]?, Error>) -> Void)
}


final class FloodRepositoryImpl: FloodRepository {
    
    var floods: [FloodReport] = [FloodReport]()
    private var listener: ListenerRegistration?
    private lazy var db: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    
    func deleteFlood(_ report: FloodReport) {
        
        guard let reportID = report.documentID else { return }
        
        self.db.collection("flooded-regions").document(reportID).delete { error in
            if let error {
                print(FloodError.firebaseError(description: error.localizedDescription))
                
            } else {
                print("✅ Document successfully deleted")
            }
        }
        
    }

    func saveNewFlood(_ report: FloodReport)  {
        var documentRef: DocumentReference? = nil
        
        documentRef = self.db.collection("flooded-regions").addDocument(
            data: report.toDictionary() as [String : Any]
        ) { error in
            if let error {
                print(FloodError.firebaseError(description: error.localizedDescription))
                
            } else if let documentID = documentRef?.documentID {
                documentRef?.updateData(["documentID": documentID]) { error in
                    if let error = error {
                        print(FloodError.custom(description: error.localizedDescription))
                        
                    } else {
                        print("✅ Document successfully saved")
                    }
                }
            }
        }
    }
    
    func observeFloods(update: @escaping (Result<[FloodReport]?, any Error>) -> Void) {
        listener = db.collection("flooded-regions").addSnapshotListener { snapshot, error in
            if let error = error {
                update(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                update(.failure(FloodError.firebaseError(description: "⚠️ Error: Snapshot nil")))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                
                if diff.type == .added {
                    if let flood = FloodReport(diff.document) {
                        self.floods.append(flood)
                        update(.success(self.floods))
                    }
                } else if diff.type == .removed {
                    if let flood = FloodReport(diff.document) {
                        self.floods = self.floods.filter { $0.documentID != flood.documentID }
                        update(.success(self.floods))
                    }
                }
                
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
}
