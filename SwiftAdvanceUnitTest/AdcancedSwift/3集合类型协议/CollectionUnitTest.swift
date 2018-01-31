//
//  CollectionUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/31.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

extension Collection
{
    
}

/// 一个能将元素入队和出队的类型
protocol Queue {
    /// self中持有的元素类型
    associatedtype Element
    /// 将newElement入队到self
    mutating func enqueue(_ newElement: Element)
    /// self出队一个元素
    mutating func dequeue() -> Element?
    
}

/// 定义一个队列 实现自己的集合
struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    /// 复杂度O(1)
    mutating func enqueue(_ newElement: FIFOQueue<Element>.Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> FIFOQueue<Element>.Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}


class CollectionUnitTest: XCTestCase {

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

}
