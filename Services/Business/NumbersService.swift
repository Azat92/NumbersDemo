//
//  NumbersService.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit

/// Service that loads data for Numbers module
public protocol NumbersService {

    /// Loads numbers and notify when they are ready
    ///
    /// - Parameter completion: block to be called on result
    /// - Returns: token to cancel request if it is not needed anymore
    func numbers(completion: @escaping (NDResult<[ListItem]>) -> Void) -> Cancellable
}

final class NDNumbersService: NumbersService {
    
    var networkService: NetworkService!
    
    func numbers(completion: @escaping (NDResult<[ListItem]>) -> Void) -> Cancellable {
        let resource = API.Numbers.demoNumbers()
        return networkService.load(resource: resource, completion: completion)
    }
}

final class NDLocalNumbersService: NumbersService {
    
    private let operationQueue = OperationQueue()
    
    func numbers(completion: @escaping (NDResult<[ListItem]>) -> Void) -> Cancellable {
        let operation = BlockOperation {
            let items = (0 ..< arc4random_uniform(100)).compactMap { _ in
                ListItem(number: Int(arc4random_uniform(256)))
            }
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
        operationQueue.addOperation(operation)
        return { [weak operation] in
            operation?.cancel()
        }
    }
}
