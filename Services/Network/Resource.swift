//
//  Resource.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

/// Protocol to be adopted when sending parameters with request to server
protocol APIParameter {
    
    /// String representation of parameter
    /// Example: String objects can return themselves
    /// for Date you can use date formatter
    /// for Numbers you can use number formatters etc
    var stringValue: String { get }
}

/// Struct that represents resource which is able to load from server
struct Resource<T> {
    
    let path: String
    let method: HTTPMethod
    let parameters: [String: APIParameter]
    let parser: (Data?) -> T?
    
    init(path: String, method: HTTPMethod, parameters: [String: APIParameter] = [:], parser: @escaping (Data?) -> T?) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parser = parser
    }
}
