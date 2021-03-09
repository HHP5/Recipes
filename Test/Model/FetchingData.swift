//
//  FetchingData.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import Foundation
import Alamofire

class FetchingData {
    
    func fetchData<T: Decodable>(for query: String = "/recipes.json", compelition: @escaping (T) -> ()) {
        
        guard let url = getURL(for: query) else {return}
        
        Alamofire.request(url, method: .get).validate().responseData { (response) in
            
            switch response.result{
            case .success(let data):
                
                do {
                    
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    compelition(obj)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    private let baseURL = "https://test.kode-t.ru"

    private func getURL(for query: String) -> URL?{
        
        let stringURL = query == "/recipes.json" ? baseURL + query : baseURL + "/recipes/\(query)"
        return URL(string: stringURL)
    }
    
}

