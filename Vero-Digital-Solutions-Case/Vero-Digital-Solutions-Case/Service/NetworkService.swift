//
//  NetworkService.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation


final class NetworkService {
    
    static let shared = NetworkService()
    private init () {}
    
    
    func getToken() {
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: loginUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = HTTPMethods.post.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        NetworkManager.shared.getToken(type: LoginResponseModel.self, url: loginUrl, request: request) { token in
            switch token {
            case .success(let token):
                let accessToken = token.oauth?.accessToken ?? ""
                print(accessToken)
                UserDefaults.standard.set(accessToken, forKey: "access_token")
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getTasks(completion: @escaping ([ItemsModelElement]?, Error?) -> ()) {
        getToken()
        
        NetworkManager.shared.getItems(type: [ItemsModelElement].self, url: urlString, method: .get) { items in
            switch items {
            case .success(let tasks):
                completion(tasks, nil)
            case .failure(let failure):
                print("this error \(failure.localizedDescription)")
                
            }
        }
        
        
        
    }
}
