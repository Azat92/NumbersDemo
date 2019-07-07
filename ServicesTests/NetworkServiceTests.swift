//
//  NetworkServiceTests.swift
//  ServicesTests
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import XCTest
@testable import Services

private class NetworkServiceTaskStub: NetworkServiceTask {
    
    var onResume: (() -> Void)?
    var onCancel: (() -> Void)?
    
    func resume() {
        onResume?()
    }
    
    func cancel() {
        onCancel?()
    }
}

private class NetworkServiceSessionStub: NetworkServiceSession {
    
    var onLoad: ((URLRequest) -> Void)?
    var taskToReturn: NetworkServiceTask!
    var completionBlock: ((Data?, URLResponse?, Error?) -> Void)?
    
    func load(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkServiceTask {
        onLoad?(request)
        completionBlock = completion
        return taskToReturn ?? NetworkServiceTaskStub()
    }
}

final class NetworkServiceTests: XCTestCase {

    private var networkServiceSessionStub: NetworkServiceSessionStub!
    private var networkService: NetworkService!
    
    override func setUp() {
        networkServiceSessionStub = NetworkServiceSessionStub()
        networkService = NDNetworkService(session: networkServiceSessionStub)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkServiceCallsLoad() {
        let resource = API.Numbers.demoNumbers()
        var didCallLoad = false
        networkServiceSessionStub.onLoad = { _ in
            didCallLoad = true
        }
        _ = networkService.load(resource: resource) { _ in
            
        }
        XCTAssertTrue(didCallLoad)
    }
    
    func testNetworkServiceResumesTask() {
        let resource = API.Numbers.demoNumbers()
        var didCallResume = false
        let task = NetworkServiceTaskStub()
        task.onResume = {
            didCallResume = true
        }
        networkServiceSessionStub.taskToReturn = task
        _ = networkService.load(resource: resource) { _ in
            
        }
        XCTAssertTrue(didCallResume)
    }
    
    func testNetworkServiceCancelsTask() {
        let resource = API.Numbers.demoNumbers()
        var didCallCancel = false
        let task = NetworkServiceTaskStub()
        task.onCancel = {
            didCallCancel = true
        }
        networkServiceSessionStub.taskToReturn = task
        networkService.load(resource: resource) { _ in
            
        }()
        XCTAssertTrue(didCallCancel)
    }
    
    func testNetworkServiceCallsSuccessCompletion() {
        let resource = API.Numbers.demoNumbers()
        let completionExpectation = expectation(description: "network service calls success completion")
        _ = networkService.load(resource: resource) { result in
            switch result {
            case .success:
                completionExpectation.fulfill()
            default:
                break
            }
        }
        let exampleJson = """
            {
                "numbers": [
                    4, 150, 12, 21, 136, 16, 3
                ]
            }
        """
        let data = exampleJson.data(using: .utf8)!
        networkServiceSessionStub.completionBlock?(data, nil, nil)
        wait(for: [completionExpectation], timeout: 1)
    }
    
    func testNetworkServiceCallsErrorOnIncorrectInput() {
        let resource = API.Numbers.demoNumbers()
        let completionExpectation = expectation(description: "network service calls error on incorrect input")
        _ = networkService.load(resource: resource) { result in
            switch result {
            case .failure:
                completionExpectation.fulfill()
            default:
                break
            }
        }
        let data = "{}".data(using: .utf8)!
        networkServiceSessionStub.completionBlock?(data, nil, nil)
        wait(for: [completionExpectation], timeout: 1)
    }
    
    func testNetworkServiceCallsErrorOnFailure() {
        let resource = API.Numbers.demoNumbers()
        let completionExpectation = expectation(description: "network service calls error on failure")
        _ = networkService.load(resource: resource) { result in
            switch result {
            case .failure:
                completionExpectation.fulfill()
            default:
                break
            }
        }
        let error = NSError(message: "Error")
        networkServiceSessionStub.completionBlock?(nil, nil, error)
        wait(for: [completionExpectation], timeout: 1)
    }
}
