//
//  NumbersPresenter.swift
//  NumbersDemoTests
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import XCTest
import Services
@testable import NumbersDemo

private class NumbersViewInputStub: NumbersViewInput {
    
    var onShowLoading: (() -> Void)?
    var onShowData: (() -> Void)?
    
    func showLoading() {
        onShowLoading?()
    }
    
    func show(error: Error) {

    }
    
    func showData() {
        onShowData?()
    }
}

final class NumbersPresenterTests: XCTestCase {
    
    private var view: NumbersViewInputStub!
    private var presenter: NumbersPresenter!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presenter = NumbersPresenter()
        // we inject localNumbersService just as a quick solution, since it already generates some test data
        // in real life we will inject here some stub to test if all cases work correctly
        presenter.numbersService = Services.servicesFactory.localNumbersService
        view = NumbersViewInputStub()
        presenter.view = view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCallShowLoaderOnViewIsReady() {
        var didCallShowLoading = false
        view.onShowLoading = {
            didCallShowLoading = true
        }
        presenter.viewIsReady()
        XCTAssertTrue(didCallShowLoading)
    }
    
    func testCallsSuccessOnReloadData() {
        // since we injected localNumbersService to presenter, it will not fail
        let callsShowDataExpectation = expectation(description: "presenter calls show data")
        view.onShowData = {
            callsShowDataExpectation.fulfill()
        }
        presenter.handleReloadData()
        wait(for: [callsShowDataExpectation], timeout: 1)
    }
    
    // here also could be a test that will check that previous requests being cancelled when new ones are coming
    // another test example is to check acceptance criteria for sorted sections and items inside sections
}
