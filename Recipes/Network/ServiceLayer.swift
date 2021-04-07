//
//  ServiceLayer.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 23.03.2021.
//

import Foundation

class ServiceLayer {
    
//    class func request<T: Codable>(router: Router, completion: @escaping (Result<[String: T], NetworkError>) -> ()) {
    class func request<T: Codable>(router: Router, completion: @escaping (Result<T,Error>) -> ()) {

        var components = URLComponents()
        
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        
        if let url = components.url{
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = router.method
            
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                
                guard error == nil else {
                    
                    completion(.failure(NetworkError.clientError))
                    return
                    
                }
                
                if let result = response as? HTTPURLResponse{
                    
                    let code = result.handleHTTPStatusCode()

                    if code == .none {
                        
                        guard let data = data else {
                            
                            completion(.failure(NetworkError.noData))
                            return
                        }
                        
                        do{
                            
                            let responseObject = try JSONDecoder().decode(T.self, from: data)
                            
                            DispatchQueue.main.async {completion(.success(responseObject))}
                            
                        }catch{
                            
                            completion(.failure(NetworkError.dataDecodingError))
                            
                        }
                        
                    }else{
                        
                        completion(.failure(code))
                    }
                }
            }
            dataTask.resume()
        }
    }
}

