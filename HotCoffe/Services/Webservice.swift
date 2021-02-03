//
//  Webservice.swift
//  HotCoffe
//
//  Created by 김동환 on 2021/02/03.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case dominError
    case urlError
}

struct Resource<T: Codable> {
    let url: URL
}

class Webservice {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.dominError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
        
    }
    
}
