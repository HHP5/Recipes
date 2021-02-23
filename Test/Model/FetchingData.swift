//
//  FetchingData.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import Foundation
import Alamofire

class FetchingData {

    private var entireRecipeList: EntireRecipeList?
    private var oneRecipe: OneRecipe?

    func fetchAllRecipes(compelition: @escaping ([RecipeStructure]) -> ()) {
        let stringURL = "https://test.kode-t.ru/recipes.json"
        guard let url = URL(string: stringURL) else { return }

        Alamofire.request(url, method: .get).responseData { (response) in

            if response.error != nil {

                print(response.error!.localizedDescription)
                return

            } else {
                guard let data = response.result.value else { return }
                do {
                    
                    self.entireRecipeList = try JSONDecoder().decode(EntireRecipeList.self, from: data)
                    compelition(self.entireRecipeList!.recipes)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetchingRecipe(for uuid: String, compelition: @escaping (RecipeStructure) -> ()) {
        let stringURL = "https://test.kode-t.ru/recipes/\(uuid)"
        guard let url = URL(string: stringURL) else { return }

        Alamofire.request(url, method: .get).responseData { (response) in

            if response.error != nil {

                print(response.error!.localizedDescription)
                return

            } else {
                guard let data = response.result.value else { return }
                do {
                    
                    self.oneRecipe = try JSONDecoder().decode(OneRecipe.self, from: data)
                    compelition(self.oneRecipe!.recipe)

                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

