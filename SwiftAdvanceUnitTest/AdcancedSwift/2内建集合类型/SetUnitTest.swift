//
//  SetUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/10.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { element in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
            
        }
    }
    
}

class SetUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInit() {
        let naturals: Set = [1,2,3,2]
        XCTAssert(naturals.contains(3))
        XCTAssert(naturals.count == 3)
    }
    
    func testSubtract() {
        let iPods: Set = ["iPod touch", "iPod nano", "iPod mini"]
        let discontinuedIPods: Set = ["iPod mini"]
        let currentIPods = iPods.subtracting(discontinuedIPods)
        XCTAssert(currentIPods.contains("iPod touch"))
        XCTAssert(!currentIPods.contains("iPod mini"))
    }

    func testIntersection() {
        let iPods: Set = ["iPod touch", "iPod nano", "iPod mini"]
        let touchscreen: Set = ["iPhone", "iPad", "iPod nano"]
        let iPodsWithTouch = iPods.intersection(touchscreen)
        XCTAssert(iPodsWithTouch.contains("iPod nano") && iPodsWithTouch.count == 1)
    }
    
    func testFormUnion() {
        var num: Set = [1,2,3,4]
        let ou: Set = [2,4,6,8,0]
        num.formUnion(ou)
        XCTAssert(num.count == 7 && num == [1,2,3,4,6,8,0])
        
    }
    
    func testUnique() {
        let num = [1,2,3,12,1,3,4,5,6,4,6]
        let uniqueNum = num.unique()
        XCTAssert(uniqueNum == [1,2,3,12,4,5,6])
    }
}
