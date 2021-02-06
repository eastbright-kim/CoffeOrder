//
//  Webservice.swift
//  HotCoffe
//
//  Created by 김동환 on 2021/02/03.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class Webservice {

    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>)->Void) {
        
        var urlRequest = URLRequest(url: resource.url)
        urlRequest.httpMethod = resource.httpMethod.rawValue
        urlRequest.httpBody = resource.body
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            // T타입의 객체를 completion에 넘김
            DispatchQueue.main.async {
                completion(.success(result))
            }
            
        }.resume()
    }
}
