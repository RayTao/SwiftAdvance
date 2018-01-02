//
//  ArrayUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/1.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

extension Sequence {
    /// 逆序数组中寻找第一个满足条件的元素 封装之后更容易理解 减少出错可能
    func last(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
    
    func accumulate<Result>(_ initialResult: Result,
                            _ nextPartialResult: (Result, Element) -> Result) -> [Result]
    {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
    
}


class ArrayUnitTest: XCTestCase {
    
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
    
    func testSlice() {
        let array = [1,2,3]
        var result = [Int]()
        // 迭代数组 for x in array
        for x in array {
            result.append(x)
        }
        XCTAssert(result == array)
        
        result.removeAll()
        // 迭代数组第一个元素的其余部分
        for x in array.dropFirst() {
            result.append(x)
        }
        XCTAssert(result == [2,3])
        
        result.removeAll()
        // 迭代数组最后1个的其余部分
        for x in array.dropLast(1) {
            result.append(x)
        }
        XCTAssert(result == [1,2])
        
        result.removeAll()
        // 列举数组对应的元素和下标
        for (num, _) in array.enumerated() {
            result.append(num)
        }
        XCTAssert(result == [0,1,2])
        
        // 寻找一个元素的位置
        let idx = array.index { $0 == 3 }
        XCTAssert(idx == 2)
        
        // 筛选符合某个标准的元素
        let filterArray = array.filter { $0 <= 1 }
        XCTAssert(filterArray == [1])
    }
    
    func testMap() {
        
        let fibs = [0,1,1,2,3,5]
        // 计算数组平方
        let squares = fibs.map { fib in "\(fib * fib)" }
        XCTAssert(squares == ["0","1","1","4","9","25"])
        
//        fibs.map
    }

    func testSort() {
        let nums = [1,3,5,2,4,6]
        // sort默认按照升序排列
        let sorted = nums.sorted()
        XCTAssert(sorted == [1,2,3,4,5,6])
        
        let customSorted = nums.sorted { (leftNum,rightNum) in leftNum > rightNum  }
        XCTAssert(customSorted == [6,5,4,3,2,1])
    }
    
    func testLastWhere() {
        let names = ["Pauls", "Elena", "Zoe"]
        let match = names.last { name in name.hasSuffix("a") }
        XCTAssert(match == "Elena")
    }
    
    func testAccumulate() {
        let plusResult = [1,2,3,4].accumulate(0, +)
        XCTAssert(plusResult == [1,3,6,10])
        
        let minusResult = [1,2,3,4].accumulate(10, -)
        XCTAssert(minusResult == [9,7,4,0])
    }
    
    func testFlatMap() {
        
    }

}
