//
//  NetworkManager.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation


protocol NetworkManagerInterface {
    func getToken<T>(type: T.Type, url: String, request: NSMutableURLRequest, completion: @escaping (Result<T,NetworkErrors >) -> ()) where T : Decodable, T : Encodable
    func getItems<T>(type: T.Type, url: String, method: HTTPMethods, completion: @escaping (Result<T, NetworkErrors>) -> ()) where T : Decodable, T : Encodable
    func handleWithData<T:Codable>(data: Data, completion: @escaping (Result<T, NetworkErrors>) -> ()) where T : Decodable, T : Encodable
}

final class NetworkManager: NetworkManagerInterface {
    
    static let shared = NetworkManager()
    private init() {}
    
    func getToken<T>(type: T.Type, url: String, request: NSMutableURLRequest, completion: @escaping (Result<T, NetworkErrors>) -> ()) where T : Decodable, T : Encodable  {
        let sesion = URLSession.shared
        
            let request = request
            
            let dataTask = sesion.dataTask(with: request as URLRequest) { [weak self] data, response, error in
                if let _ = error {
                    completion(.failure(.generalError))
                }else if let data = data {
                    self?.handleWithData(data: data, completion: { response in
                        completion(response)
                    })
                } else {
                    completion(.failure(.invalidURL))
                }
            }
            dataTask.resume()
    }
    
    func getItems<T>(type: T.Type, url: String, method: HTTPMethods, completion: @escaping (Result<T, NetworkErrors>) -> ()) where T : Decodable, T : Encodable {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            print("There is a no Access token")
            return
        }
        
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
                if let _ = error {
                    completion(.failure(.generalError))
                } else if let data = data {
                    self?.handleWithData(data: data, completion: { response in
                        completion(response)
                    })
                } else {
                    completion(.failure(.invalidURL))
                }
            }
            dataTask.resume()
            
        }
        
    }
     
    func handleWithData<T>(data: Data, completion: @escaping (Result<T, NetworkErrors>) -> ()) where T : Decodable, T : Encodable  {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
        } catch  {
            completion(.failure(.invalidData))
        }
    }
    
}
