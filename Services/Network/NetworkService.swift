//
//  NetworkService.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import Utils

/// Service that loads data from server
protocol NetworkService {
    
    /// Loads given resource and notify when it is ready
    ///
    /// - Parameters:
    ///   - resource: resource to load
    ///   - completion: block that will be called at the end of process
    /// - Returns: token which you can use to cancel request if you don't need it anymore
    func load<T>(resource: Resource<T>, completion: @escaping (NDResult<T>) -> Void) -> Cancellable
}

private extension HTTPMethod {
    
    var stringValue: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

private extension Resource {
    
    var headers: [String: String] {
        return ["Accept": "application/json"]
    }
    
    var url: URL {
        var components = URLComponents(string: path)!
        components.queryItems = parameters.map { key, param in
            return URLQueryItem(name: key, value: param.stringValue)
        }
        return components.url!
    }
}

protocol NetworkServiceTask: AnyObject {
    
    func resume()
    func cancel()
}

extension URLSessionDataTask: NetworkServiceTask {
    
}

protocol NetworkServiceSession {
    
    func load(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkServiceTask
}

extension URLSession: NetworkServiceSession {
    
    func load(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkServiceTask {
        return dataTask(with: request, completionHandler: completion)
    }
}

final class NDNetworkService: NetworkService {
    
    private let session: NetworkServiceSession
        
    init(session: NetworkServiceSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    private var generalError: NSError {
        return NSError(message: Localizations.Services.generalNetworkError)
    }
    
    func load<T>(resource: Resource<T>, completion: @escaping (NDResult<T>) -> Void) -> Cancellable {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.stringValue
        for (key, value) in resource.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = session.load(request: request) { data, _, error in
            if let result = resource.parser(data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? self.generalError))
                }
            }
        }
        task.resume()
        return { [weak task] in
            task?.cancel()
        }
    }
}

