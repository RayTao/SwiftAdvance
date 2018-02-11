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


class CollectionUnitTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testFIFOQueue() {
    
        var q = FIFOQueue<String>()
        for x in ["1","2","foo","3"] {
            q.enqueue(x)
        }
        XCTAssert(Array(q) == ["1","2","foo","3"])
        XCTAssert(q[0] == "1")
        XCTAssert(q.dequeue() == "1" && Array(q) == ["2","foo","3"])
        XCTAssert(q[0] == "2")
        
        let q2: FIFOQueue<Int> = [1,2,3,6,0,3,2,1]
        XCTAssert(q2[0] == 1)
        
        var forResult: [Int] = []
        for x in q2 {
            forResult.append(x)
        }
        XCTAssert(forResult == [1,2,3,6,0,3,2,1])
    }
    
    func testList() {
        var stack: List<Int> = [3,2,1]
        var a = stack
        var b = stack
        
        XCTAssert(a.pop() == Optional(3))
        XCTAssert(a.pop() == Optional(2))
        
        _ = stack.pop()
        stack.push(4)
        
        XCTAssert(b.pop() == Optional(3))
        XCTAssert(b.pop() == Optional(2))
        
        XCTAssert(stack.pop() == Optional(4))
        XCTAssert(stack.pop() == Optional(2))
        XCTAssert(stack.pop() == Optional(1))
        
        let list: List = [1,2,3]
        var result: [Int] = []
        for x in list {
            result.append(x)
        }
        XCTAssert(result == [1,2,3])

        XCTAssert(list.contains(2))
        XCTAssert(list.flatMap {Int($0) } == [1,2,3])
        XCTAssert(list.elementsEqual([1,2,3]))
        XCTAssert(list.description == "List: (1, 2, 3)")
        
    }
    
    func testListCollecion() {
        var list: List = ["one", "two", "threee"]
        XCTAssert(list.first == Optional("one"))
//        XCTAssert(list.index(of: "two") == ListIndex(node: ,tag:1)))
        XCTAssert(list.count == 3)
        XCTAssert(list.pop() == "one")
        XCTAssert(list.count == 2)
        _ = list.pop()
        _ = list.pop()
        _ = list.pop()
        XCTAssert(list.count == 0)
    }
    
    func testSlice() {
        let numbers = [1,2,3]
        let sliceArray = Array(PrefixIterator(numbers))
        XCTAssert(sliceArray[0].first == 1)
        
    }
    
    func testReversed() {
        let list: List = ["red", "green", "blue"]
        let reversed = list.reversed()
        XCTAssert(reversed as Any is List<String>)
        let reversedArray: [String] = list.reversed()
        XCTAssert(reversedArray as Any is [String])
        XCTAssert(list.reversed().elementsEqual(list.reversed() as [String]))
    }
    
    /// MutableCollection允许改变集合中的元素值 但是不允许改变集合的长度或者元素顺序
    /// Dictionary和Set是无序的集合，通过下标赋值时对应元素的索引被改变了，所以不满足MutableCollection
    func testMutable() {
        var numbers = [1,2,3,4,5]
        numbers.swapAt(0, 1)
        XCTAssert(numbers[0] == 2)
        
        var playlist: FIFOQueue = ["hello", "you", "world"]
        playlist.swapAt(0, 1)
        XCTAssert(playlist.first == "you")
    }
    
    func testRangeReplaceable() {
        var array = [1,2,3,4,5]
        XCTAssert(array.removeFirst() == 1 && array == [2,3,4,5])
        array.replaceSubrange(1...2, with: [233])
        XCTAssert(array == [2,233,5])
        
        var numbers: FIFOQueue = [233,177,666]
        numbers.append(2)
        XCTAssert(Array(numbers) == [233,177,666,2])
        numbers.replaceSubrange(1...2, with: [233])
        XCTAssert(Array(numbers) == [233,233,2])

        
    }
    
    
}
