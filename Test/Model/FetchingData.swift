//
//  FetchingData.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import Foundation
import Alamofire

class FetchingData {
    
    let baseURL = "https://test.kode-t.ru"
    
    func fetchData<T: Decodable>(for url: String = "/recipes.json", compelition: @escaping (T) -> ()) {
        
        let stringURL = url == "/recipes.json" ? baseURL + url : baseURL + "/recipes/\(url)"
        guard let url = URL(string: stringURL) else { return }
        
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
    
    
}

