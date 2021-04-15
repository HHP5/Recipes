//
//  ServiceLayer.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 23.03.2021.
//

import Foundation

class ServiceLayer {
     func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> Void) {
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
		let dataTask = session.dataTask(with: urlRequest) { [self] data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
			if let result = response as? HTTPURLResponse {
				
				switch result.statusCode {
				
				case 200...299:
										
					DispatchQueue.main.async {
						
						completion(handleData(T.self, data: data))
						
					}

				default:
					
					completion(.failure(result.handleHTTPStatusCode()))
					return
					
				}
			}
        }
        dataTask.resume()
    }
	
	private func handleData<T: Codable>(_ type: T.Type, data: Data?) -> Result<T, Error> {
		guard let data = data else { return .failure(NetworkError.noData) }
		
		do {
			
			let responseObject = try JSONDecoder().decode(type, from: data)
			
			return .success(responseObject)
			
		} catch {
			
			return .failure(NetworkError.dataDecodingError)
		}
	}
}
