//
//  IteratorUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/29.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

class IteratorUnitTest: XCTestCase {

    /// 无限序列的迭代器
    struct ConstantIterator: IteratorProtocol {
        typealias Element = Int
        mutating func next() -> Int? {
            return 1
        }
    }
    
    struct ConstantSequence: Sequence {
        
        func makeIterator() -> ConstantIterator {
            return ConstantIterator()
        }

    }
    
    /// 有限序列的迭代器
    struct PrefixIterator: IteratorProtocol {
        typealias Element = String
        
        let string: String
        var offset: String.Index
        
        init(string: String) {
            self.string = string
            offset = string.startIndex
        }
        
        mutating func next() -> String? {
            guard offset < string.endIndex else {
                return nil
            }
            
            offset = string.index(after: offset)
            return String(string[string.startIndex..<offset])
        }
        
    }
    
    struct PrefixSequence: Sequence {
        let string: String
        
        func makeIterator() -> PrefixIterator {
            return PrefixIterator(string: string)
        }
        
    }
    
    func testPrefix() {
        var result: [Int] = []
        for i in ConstantSequence().prefix(6) {
            result.append(i)
        }
        XCTAssert(result == [1,1,1,1,1,1])
    }
    
    func testValueAndReference() {
        let seq = stride(from: 0, to: 10, by: 1)
        var i1 = seq.makeIterator()
        let _ = i1.next()
        let _ = i1.next()
        
        var i2 = i1
        XCTAssert(i1.next() == 2)
        XCTAssert(i2.next() == 2)
        
        let i3 = AnyIterator(i1)
        let i4 = i3
        XCTAssert(i3.next() == 3)
        XCTAssert(i4.next() == 4)

        
    }
    
    func testForIn() {
        var result: [String] = []
        for prefix in PrefixSequence(string: "Hello") {
            result.append(prefix)
        }
        XCTAssert(result == ["H","He","Hel","Hell","Hello"])
    }
    
    func testMap() {
        let result = PrefixSequence(string: "Hello").map { $0.uppercased() }
        XCTAssert(result == ["H","HE","HEL","HELL","HELLO"])
    }
    
    func testAnyIterater() {
        func fibsIterator() -> AnyIterator<Int> {
            var state = (0, 1)
            return AnyIterator {
                let upcomingNumber = state.0
                state = (state.1, state.0 + state.1)
                return upcomingNumber
            }
        }
        
        let fibsSequence = AnySequence(fibsIterator)
        let result = Array(fibsSequence.prefix(5))
        XCTAssert(result == [0,1,1,2,3])
    }
    
    func testSequenceFuc() {
        let randomNumber = sequence(first: 100) { (pre: UInt32) in
            let newValue = arc4random_uniform(pre)
            guard newValue > 0 else { return nil }
            
            return newValue
        }
        let result = Array(randomNumber)
        XCTAssert(result.first == 100 && result.last! > 0)
        
        let fibsSequence2 = sequence(state: (0, 1)) {
            (state: inout (Int, Int)) -> Int? in
           
            let upcomingNumber = state.0
            state = (state.1, state.0 + state.1)
            return upcomingNumber
        }
        
        XCTAssert(Array(fibsSequence2.prefix(5)) == [0,1,1,2,3])
        
    }
    
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
