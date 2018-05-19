//
//  OperationTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/3/20.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

class CustomOpertaionTest: Operation {
    
    private var _threadDes: String = ""
    private var _lock = pthread_mutex_t()
    
    var threadDes: String {
        get {
            return _threadDes
        }
        set {
            pthread_mutex_lock(&_lock)
            
            _threadDes = newValue
            pthread_mutex_unlock(&_lock)
        }
    }
    
    override func main() {
        //自动释放池避免内存泄露
        autoreleasepool {
            print("这是一个测试: " + String(describing: Thread.current))
            if Thread.isMainThread {
                self.threadDes.append("main")
                
            } else {
                self.threadDes.append("otherThread")
            }
        }
    }
}


class OperationTest: XCTestCase {

    private var _threadDes: String = ""
    private var _lock = pthread_mutex_t()
    var threadDes: String {
        get {
            return _threadDes
        }
        set {
            pthread_mutex_lock(&_lock)
            
            _threadDes = newValue
            pthread_mutex_unlock(&_lock)
        }
    }
    
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

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        threadDes = ""
        expectationA = expectation(description: "a")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    /// 直接调用start方法时,系统并不会开辟一个新的线程去执行任务,任务会在当前线程同步执行initblock
    func testOperationStart() {
        let op = BlockOperation.init {
            if Thread.isMainThread {
                self.threadDes.append("main")
                self.expectationA.fulfill()
            }
            print("op excute block")
        }
        op.start()
        print("op start")
        waitForExpectations(timeout: 3) { _ in
            XCTAssertTrue(self.threadDes == "main")
        }
    }
    
    /// BlockOperation封装的操作数大于1的时候,开辟新线程且执行异步操作
    func testExecutionBlock() {
        autoreleasepool {
            
        }
        let op = BlockOperation.init {
            if Thread.isMainThread {
                self.threadDes.append("main")
                
            } else {
                self.threadDes.append(String(describing: Thread.current))
            }
            print("current thread0: " + String(describing: Thread.current))
        }
        op.addExecutionBlock {
            if Thread.isMainThread {
                self.threadDes.append("main")
                
            } else {
                self.threadDes.append("-thread1")
            }
            print("current thread1: " + String(describing: Thread.current))
        }
        op.addExecutionBlock {
            if Thread.isMainThread {
                self.threadDes.append("main")
                
            } else {
                self.threadDes.append("-thread2")
            }
            print("current thread2: " + String(describing: Thread.current))
        }
        op.completionBlock = {
            
            self.expectationA.fulfill()
            
        }
//        op.start()
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 2
        opQueue.addOperation(op)
        let op2 = CustomOpertaionTest()
        opQueue.addOperation(op2)
        op2.addDependency(op)
        
        waitForExpectations(timeout: 30) { _ in
            XCTAssertTrue(self.threadDes != "main" && !self.threadDes.isEmpty)
            print("current des: " + self.threadDes)

        }
        
    }
    
    func testCustomOp() {
        let op = CustomOpertaionTest()
        /********************1.直接执行，同步***************/
        op.start()
        XCTAssert(op.threadDes == "main")
        
        let opQueue = OperationQueue()
        let op2 = CustomOpertaionTest()
        /********************2.添加到队列，异步***************/
        opQueue.addOperation(op2)
        op2.completionBlock = {
            self.expectationA.fulfill()
        }
        
        waitForExpectations(timeout: 3.0) { _ in
            XCTAssert(op2.threadDes == "otherThread")

        }
    }
    
    
}
