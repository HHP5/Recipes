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


        Alamofire.request(url, method: .get).responseData { (response) in

            if response.error != nil {

                print(response.error!.localizedDescription)
                return

            } else {
                guard let data = response.result.value else { return }
                do {
                    
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    compelition(obj)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    
}

