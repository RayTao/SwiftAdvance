//
//  GCDTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/3/20.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

class GCDTest: XCTestCase {

    private var _lock = pthread_mutex_t()
    fileprivate let queue = DispatchQueue(label: "Com.BigNerdCoding.SafeArray", attributes: .concurrent)
    private var _expectationA: XCTestExpectation?
    var expectationA: XCTestExpectation {
        get {
            return _expectationA == nil ? expectation(description: "a") : _expectationA!
        }
        set {
            pthread_mutex_lock(&_lock)
            
            _expectationA = newValue
            pthread_mutex_unlock(&_lock)
        }
    }
    private var _result: String?
    var result: String {
        get {
            var result: String = ""
            queue.sync { result = _result ?? "" }

            return result
        }
        set {
            pthread_mutex_lock(&_lock)
            
            _result = newValue
            pthread_mutex_unlock(&_lock)
        }
    }

    
    func setUpExpection() {
        _expectationA = expectation(description: "a")
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

    /// 获取主线程串行队列 代码执行在主线程
    func testGetMainQueue() {
        setUpExpection()
        
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            assert(Thread.current.isMainThread)
            self.expectationA.fulfill()
        }
        /// 死锁
//        mainQueue.sync {
//            assert(Thread.current.isMainThread)
//            self.expectationA.fulfill()
//        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    /// 异步线程的执行顺序是不确定的。几乎同步开始执行
    /// 为了线程安全最好读写在同一个线程
    func testGlobalQueue() {
        let globalQueue = DispatchQueue.global()
        // 全局并发队列同步执行任务，在主线程执行会导致页面卡顿
        var result = "1"
        globalQueue.sync {
            result.append("2")
        }
        result.append("3")
        XCTAssert(result == "123")
        
        // 全局并发队列异步执行任务，在主线程运行，会开启新的子线程去执行任务，页面不会卡顿
        setUpExpection()
        result = "1"
        globalQueue.async {
            result.append("2")
            assert(Thread.current.isMainThread == false)
            self.expectationA.fulfill()
        }
        result.append("3")
        waitForExpectations(timeout: 3.0) { _ in
            XCTAssert(result == "132")
            
        }
    }
    
    func testGQAsync(){
        // 全局并发队列异步执行任务，在主线程运行，会开启新的子线程去执行任务，页面不会卡顿
        setUpExpection()
        var result = SafeArray<Int>()
        result.append(0)
        var des = "0"
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global()
        globalQueue.async {
            mainQueue.sync {
                des.append("1")
            }
            result.append(1)
            XCTAssert(result.contains(1))
            assert(Thread.current.isMainThread == false)

        }
        globalQueue.async {

            result.append(2)
            XCTAssert(result.contains(2))
            assert(Thread.current.isMainThread == false)
            mainQueue.sync {
                des.append("2")
            }
        }
        globalQueue.async {

            result += 3
            XCTAssert(result.contains(3))
            assert(Thread.current.isMainThread == false)
            mainQueue.sync {
                des.append("3")
            }
        }
        globalQueue.async {

            result += 4
            XCTAssert(result.contains(4))
            assert(Thread.current.isMainThread == false)
            mainQueue.sync {
                des.append("4")
            }
        }
//        mainQueue.asyncAfter(deadline: 2) {
//            self.expectationA.fulfill()
//        }
        globalQueue.asyncAfter(deadline: 2) {
            self.expectationA.fulfill()
        }
        
        
        waitForExpectations(timeout: 3.0) { _ in
            XCTAssert(result.array != [0,1,2,3,4] &&
                result.array.count == 5)
            print(result.array)
            print(des)

        }
    }
    
    /// 当前线程等待串行队列中的子线程执行完成之后再执行，
    /// 串行队列中先进来的子线程先执行任务，执行完成后，再执行队列中后面的任务
    func testCusSync() {
        let label = "com.dullgrass.serialQueue"
        let serialQueue = DispatchQueue(label: label)
        var result = "1"
        serialQueue.sync {
            result += "2"
        }
        serialQueue.sync {
            result += "3"
        }
        serialQueue.sync {
            result += "4"
        }
        XCTAssert(result == "1234")
        
//        serialQueue.sync { //该代码段后面的代码都不会执行，程序被锁定在这里
//            serialQueue.sync {
//            }
//        }
    }
    
    /// 异步执行串行队列，嵌套同步执行串行队列，同步执行的串行队列中的任务将不会被执行，其他程序正常执行
    func testCusAsync() {
        let label = "com.dullgrass.serialQueue"
        let serialQueue = DispatchQueue(label: label)
        let mainQueue = DispatchQueue.main
        var result = "1"
        serialQueue.async {
            mainQueue.sync {
                result += "2"
            }
            // 死锁
//            serialQueue.sync {
//                mainQueue.async {
//                    result += "3"
//                }
//            }
        }
        setUpExpection()
        mainQueue.asyncAfter(deadline: 3) {
            self.expectationA.fulfill()
        }
        waitForExpectations(timeout: 3.0) { _ in
            XCTAssert(result == "12")
        }
    }
    
    /// 自定义并发队列嵌套执行同步任务（不会产生死锁，程序正常运行）
    func testConQueueSync() {
        let label = "com.dullgrass.conCurrentQueue"
        let conQueue = DispatchQueue(label: label, attributes: .concurrent)
        var result = ""
        conQueue.sync {
//            mainQueue.sync {
                result += "1"
//            }
            
        }
        conQueue.sync {
//            mainQueue.sync {
                result += "2"
//            }
        }
        result += "3"
        XCTAssert(result == "123")
        
        result = ""
        conQueue.sync {
            result += "0"
            conQueue.sync {
                result += "1"
            }
        }
        XCTAssert(result == "01")
    }
    
    /// 当遇到需要执行多个线程并发执行，然后等多个线程都结束之后，再汇总执行结果时可以用group queue
    func testGroupQueue() {
        let conCurrentGlobalQueue = DispatchQueue.global()
        let groupQueue = DispatchGroup()
        let mainQueue = DispatchQueue.main
        var result = "1"
        
        conCurrentGlobalQueue.async(group: groupQueue,
                                    execute: DispatchWorkItem(block: {
                                        mainQueue.sync {
                                            result += "2"
                                        }
                                    }))
        conCurrentGlobalQueue.async(group: groupQueue,
                                    execute: DispatchWorkItem(block: {
                                        mainQueue.sync {
                                            result += "3"
                                        }
                                    }))
        setUpExpection()
        groupQueue.notify(queue: conCurrentGlobalQueue) {
            mainQueue.sync {
                result += "4"
                self.expectationA.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3.0) { _ in
            XCTAssert(result.count == 4)
        }
    }
}
