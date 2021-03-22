//
//  FetchingData.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import Foundation

class FetchingData {
    
    func fetchData<T: Decodable>(for query: String = "/recipes.json", completion: @escaping (Result<[String:T],NetworkingError>) -> Void) {
        
        guard let url = getURL(for: query) else {
            completion(.failure(.badURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard error == nil else {
                completion(.failure(.clientError))
                return
            }

            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.invalidRequest))
                return
            }
          
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do{
                let value = try JSONDecoder().decode([String:T].self, from: data)

                DispatchQueue.main.async {

                    completion(.success(value))
                }
            }catch{
                
                completion(.failure(.dataDecodingError))
            }
            
        }
        task.resume()
        
    }
    

    private let baseURL = "https://test.kode-t.ru"

    private func getURL(for query: String) -> URL?{
        
        let stringURL = query == "/recipes.json" ? baseURL + query : baseURL + "/recipes/\(query)"
        return URL(string: stringURL)
    }
}

