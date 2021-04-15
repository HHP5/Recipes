//
//  ServiceLayer.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 23.03.2021.
//

import Foundation

class ServiceLayer {
    class func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents()
        
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        
        guard let url = components.url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
			if let result = response as? HTTPURLResponse {
				
				switch result.statusCode {
				
				case 200...299:
					
					guard let data = data else {
						
						completion(.failure(NetworkError.noData))
						return
					}
					
					do {
						
						let responseObject = try JSONDecoder().decode(T.self, from: data)
						
						DispatchQueue.main.async {completion(.success(responseObject))}
						
					} catch {
						
						completion(.failure(NetworkError.dataDecodingError))
						return
					}
					
				default:
					
					completion(.failure(result.handleHTTPStatusCode()))
					return
					
				}
			}
        }
        dataTask.resume()
    }
}
