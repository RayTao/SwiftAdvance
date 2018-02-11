//
//  CollectionGenericUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/11.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest


class CollectionGenericUnitTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBinaraySearch() {
        let a = ["a","b","c","d","e","f","g"]
        let r = a.reversed()
        XCTAssert(r.binarySearch(for: "g", areInIncreasingOrder: >) == r.startIndex)
        
        let s = a[2..<5]
        XCTAssert(s.startIndex == 2)
        XCTAssert(s.binarySearch(for: "c") == s.startIndex)
    }
    

}
