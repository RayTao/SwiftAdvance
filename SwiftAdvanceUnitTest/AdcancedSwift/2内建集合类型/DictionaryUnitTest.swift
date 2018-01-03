//
//  DictionaryUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/2.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value)
    {
        for (k, v) in other {
            self[k] = v
        }
    }
    
    init<S>(_ sequence: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value)
    {
        self = [:]
        self.merge(sequence)
    }
    
    func mapValues<NewValue>(transform: (Value) -> NewValue) -> [Key: NewValue]
    {
        return Dictionary<Key, NewValue>(map { (key, value) in
            return (key, transform(value))
        })
    }
}

class DictionaryUnitTest: XCTestCase {
    
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
    
    func testMerge() {
        var dic = ["1": 1,
                   "2": 2]
        dic.merge([("3", 3)])
        XCTAssert(dic == ["1": 1,"2": 2,"3": 3])
    }

    func testInit() {
        let params = [1: "1"]
        let dic: [Int: String] = Dictionary(params)
        XCTAssert(dic == [1: "1"])
    }
    
    func testMapValues() {
        let dic = ["1": 1,
                   "2": 2]
        let mapDic = dic.mapValues { value in value*2  }
        XCTAssert(mapDic == ["1": 2,"2": 4])
    }
}
