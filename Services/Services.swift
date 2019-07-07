//
//  Services.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

/// Closure that represents any cancellable action
public typealias Cancellable = () -> Void

/// Enum that represents any failable type of data
///
/// - success: data is correct
/// - failure: there is some issue with data
public enum NDResult<T> {
    
    case success(T)
    case failure(Error)
}

/// General entry point to access services
public final class Services {
    
    /// Factory that will give required services
    public static let servicesFactory = ServicesFactory()
}

/// Factory for services. Current implementation is straightforward,
/// but we could use different techniques to manage life cycles of different services
public final class ServicesFactory {
    
    private let networkService = NDNetworkService()
    
    /// Service that loads numbers from remote server
    public var remoteNumbersService: NumbersService {
        let service = NDNumbersService()
        service.networkService = networkService
        return service
    }
    
    /// Service that provides random numbers locally
    public var localNumbersService: NumbersService {
        return NDLocalNumbersService()
    }
}
