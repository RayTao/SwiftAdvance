//
//  MostFrequenceTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/3/20.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

class MostFrequenceTest: XCTestCase {

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

    func testM() {
        var result = MostFrequence.mostFrequence(s: "Aout machine")
        XCTAssertTrue(result == "acehimnotu")
        result = MostFrequence.mostFrequence(s: "Aaaccbbihj**//..ppp")
        XCTAssertTrue(result == "apbchij")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
