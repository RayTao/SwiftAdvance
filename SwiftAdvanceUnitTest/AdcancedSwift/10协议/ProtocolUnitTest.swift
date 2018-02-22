//
//  ProtocolTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/22.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

class ProtocolUnitTest: XCTestCase {

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

    func testType() {
        let simple = ProtocolSimple()
        XCTAssert(simple.funcB() == simpleText + funcBText)
        XCTAssert(simple.funcC() == simpleText + funcCText)
        
        let otherSimple: TestProtocol = ProtocolSimple()
        // funcC不存在协议定义里 存在容器静态派发
        XCTAssert(otherSimple.funcC() == funcCText)
        // funcB不存在协议定义里 存在容器动态派发
        XCTAssert(otherSimple.funcB() == simpleText + funcBText)

    }
    
    func testDiscardType() {
        let a = SequenceUnitTest.ConstantIterator()
        // 关联类型协议不能直接使用
//        let iterator: IteratorProtocol = a //error
        
        var iterator: AnyProtocolIterator<Int> = AnyProtocolIterator(a)
        iterator = AnyProtocolIterator(SequenceUnitTest().randomNumber)
        let next = iterator.next()!
        XCTAssert(next > 0 && next <= 100 )
    }
    
}
