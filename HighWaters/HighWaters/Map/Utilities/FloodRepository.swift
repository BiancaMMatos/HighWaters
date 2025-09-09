//
//  FloodRepository.swift
//  HighWaters
//
//  Created by Bianca Maciel on 27/08/25.
//

import CoreLocation
import FirebaseFirestore


protocol FloodRepository {
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
            let floods = snapshot.documents.compactMap { FloodReport($0) }
            update(.success(floods))
        }
    }
    
    func saveNewFlood(_ report: FloodReport)  {
        var documentRef: DocumentReference? = nil
        
        documentRef = self.db.collection("flooded-regions").addDocument(data: report.toDictionary() as [String : Any]) { error in
            
            if let error {
                
                print("🚨 Error: \(error.localizedDescription)")
                
                if let firestoreError = error as? FirestoreErrorCode {
                    print("⚠️ Error: \(firestoreError.localizedDescription). Code: \(firestoreError.errorCode)")
                }
                
            } else if let documentID = documentRef?.documentID {
                var updatedReport = report
                updatedReport.documentID = documentID
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
}
