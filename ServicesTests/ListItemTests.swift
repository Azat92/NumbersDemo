//
//  ListItemTests.swift
//  ServicesTests
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import XCTest
@testable import Services

final class ListItemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNonByteItemsAreNil() {
        XCTAssertNil(ListItem(number: -1))
        XCTAssertNil(ListItem(number: -4))
        XCTAssertNil(ListItem(number: -100))
        XCTAssertNil(ListItem(number: 256))
        XCTAssertNil(ListItem(number: 259))
        XCTAssertNil(ListItem(number: 1000))
    }

    func testSectionParsesCorrect() {
        for i in 0 ..< 255 {
            let item = ListItem(number: i)
            XCTAssertNotNil(item)
            if i % 4 == 0 {
                XCTAssertTrue(item!.section == 0)
            } else if i % 4 == 1 {
                XCTAssertTrue(item!.section == 1)
            } else if i % 4 == 2 {
                XCTAssertTrue(item!.section == 2)
            } else {
                XCTAssertTrue(item!.section == 3)
            }
        }
    }
    
    func testCheckmarkParsesCorrect() {
        for i in 0 ..< 255 {
            let item = ListItem(number: i)
            XCTAssertNotNil(item)
            if i < 128 {
                XCTAssertFalse(item!.isSelected)
            } else {
                XCTAssertTrue(item!.isSelected)
            }
        }
    }
    
    func testValueParsesCorrect() {
        for i in 0 ..< 31 {
            for j in 0 ..< 3 {
                let selectedNumber = 0b1 << 7 + i << 2 + j
                let item1 = ListItem(number: selectedNumber)
                XCTAssertNotNil(item1)
                XCTAssertTrue(item1!.section == j)
                XCTAssertTrue(item1!.value == i)
                XCTAssertTrue(item1!.isSelected)
                
                let unSelectedNumber = 0b0 << 7 + i << 2 + j
                let item2 = ListItem(number: unSelectedNumber)
                XCTAssertNotNil(item2)
                XCTAssertTrue(item2!.section == j)
                XCTAssertTrue(item2!.value == i)
                XCTAssertFalse(item2!.isSelected)
            }
        }
    }
}
