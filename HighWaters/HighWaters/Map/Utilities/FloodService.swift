//
//  FloodService.swift
//  HighWaters
//
//  Created by Bianca Maciel on 08/09/25.
//

import Foundation

protocol FloodServiceProtocol {
    func removeFloodListener()
    func saveFlood(_ report: FloodReport)
    func observeFloods(update: @escaping (Result<[FloodReport]?, Error>) -> Void)
}


final class FloodService: FloodServiceProtocol {
    
    let repository: FloodRepository = FloodRepositoryImpl()
    
    func observeFloods(update: @escaping (Result<[FloodReport]?, any Error>) -> Void) {
        repository.observeFloods(update: update)
    }
    
    func saveFlood(_ report: FloodReport) {
        repository.saveNewFlood(report)
    }
    
    func removeFloodListener() {
        if let repo = repository as? FloodRepositoryImpl {
            repo.removeListener()
        }
    }
    
}


enum FloodError: Error, LocalizedError {
    case firebaseError(description: String)
    
    var errorDescription: String? {
        switch self {
        case .firebaseError(let description):
            "🚨 Firebase error: \(description)"
        }
    }
}
