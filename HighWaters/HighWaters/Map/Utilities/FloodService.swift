//
//  FloodService.swift
//  HighWaters
//
//  Created by Bianca Maciel on 08/09/25.
//

import Foundation

protocol FloodServiceProtocol {
    func reportFloods(completion: @escaping (Result<[FloodReport]?, Error>) -> Void) throws
    func updateFloods(_ floods: [FloodReport])
}


final class FloodService: FloodServiceProtocol {
    
    let repository: FloodRepository
    
    init(repository: FloodRepository) {
        self.repository = repository
    }
    
    func reportFloods(completion: @escaping (Result<[FloodReport]?, any Error>) -> Void) throws {
        do {
            try repository.fetchFloods { [weak self] result in
                switch result {
                case .success(let floods):
                    if let floods = floods {
                        self?.updateFloods(floods)
                    }
                    completion(.success(floods))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            throw FloodError.firebaseError(description: error.localizedDescription)
        }
    }
    
    func updateFloods(_ floods: [FloodReport]) {
        DispatchQueue.main.async {
            floods.forEach {
                self.repository.saveNewFlood($0)
            }
        }
    }

}


enum FloodError: Error, LocalizedError {
    case firebaseError(description: String)
    
    var errorDescription: String? {
        switch self {
        case .firebaseError(let description):
            "Firebase error: \(description)"
        }
    }
}
