//
//  API.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

enum HTTPMethod {
    
    case get
}

final class API {
    
    static func jsonParser<T: Decodable>(_ input: Data?) -> T? {
        guard let data = input else { return nil }
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode(T.self, from: data)
    }
}
