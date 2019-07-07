//
//  API+Numbers.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

private struct NumbersList: Decodable {
    
    let numbers: [Int]
}

extension API {
    
    struct Numbers {
        
        static func demoNumbers() -> Resource<[ListItem]> {
            let path = Constants.apiBaseUrl + "/numbers.json"
            return Resource(path: path, method: .get) { data in
                let numbersList: NumbersList? = API.jsonParser(data)
                return numbersList?.numbers.compactMap(ListItem.init)
            }
        }
    }
}
