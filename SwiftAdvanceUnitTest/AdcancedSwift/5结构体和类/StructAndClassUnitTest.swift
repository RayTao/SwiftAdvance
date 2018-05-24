//
//  StructAndClassUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by apple on 2018/5/24.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


enum TestError: Error {
    //        init?(rawValue: String) {
    //
    //        }
    //
    //        var rawValue: String
    
    
    //        var rawValue: String
    
    typealias RawValue = String
    
    case SomeExpectedError
    case SomeUnexpectedError
}

class StructAndClassUnitTest: XCTestCase {

   
    
    class BinaryScanner {
        var position: Int
        let data: Data
        init(data: Data) {
            self.position = 0
            self.data = data
        }
        
        func scanByte() -> UInt8? {
            guard position < data.endIndex else {
                return nil
            }
            position += 1
            let someItem = data[exist: position-1]
            if let _ = someItem {
                return someItem
            }
            return 0
        }
    }
    
    func scanRemainingBytes(scanner: BinaryScanner) throws -> [UInt8] {
        var result: [UInt8] = []
        while let byte = scanner.scanByte()  {
            result.append(byte)
            if (byte == 0) {
                throw TestError.SomeUnexpectedError
            }
        }
        return result
    }

    
    func testScan() {
        let scaner = BinaryScanner(data: "hi".data(using: .utf8)!)
        if let result = try? scanRemainingBytes(scanner: scaner) {
            XCTAssert(result == [104,105])
        } else {
            XCTFail()
        }
        
        
        // 但是在多线程下 下标访问容易越界
        var indexBoundExpection = false
        for _ in 0..<Int.max {
            if (indexBoundExpection) {
                return
            }
            
            let newScanner = BinaryScanner(data: "hi".data(using: .utf8)!)
            DispatchQueue.global().async {
                if let _ = try? self.scanRemainingBytes(scanner: newScanner) {}
                else {
                    indexBoundExpection = true
                }
            }
            if let _ = try? self.scanRemainingBytes(scanner: newScanner) {}
        }
        
        XCTAssert(indexBoundExpection)
    }
    
    /// 因为isKnownUniquelyReferenced对OC对象都返回false 所以需要用swift包装一层
    final class Box<A> {
        var unbox: A
        init(_ value: A) { self.unbox = value }
    }
    
    struct MyData {
        fileprivate var _data: Box<NSMutableData>
        var _dataForWriting: NSMutableData {
            mutating get {
                if !isKnownUniquelyReferenced(&_data) {
                    _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                }
                return _data.unbox
            }
        }
        
        init(_ data: NSData) {
            self._data = Box(data.mutableCopy() as! NSMutableData)
        }
        
        mutating func append(_ other: MyData) {
            _dataForWriting.append(other._data.unbox as Data)
        }
    }
    
    func testWriteInCopy() {
        // 当元素唯一的时候 内存的改变在原地发生 否则会发生复制 这就是写时复制
        // 当类型内部含有一个或者多个可变引用 同时想要保持值语义 不想不必要的复制 要为类型实现写时复制
        var x = Box(NSMutableData())
        // isKnownUniquelyReferenced检查引用唯一性
        XCTAssert(isKnownUniquelyReferenced(&x))
        let y = x
        XCTAssert(!isKnownUniquelyReferenced(&x))
        
        let someBytes = MyData(NSData(base64Encoded: "wAEP/w==", options: [])!)
        
        var empty = MyData(NSData())
        let emptyCopy = empty
        for _ in 0..<5 {
            empty.append(someBytes)
        }
        XCTAssert(emptyCopy._data.unbox.length == 0)
        XCTAssert(empty._data.unbox.length > 5)
        
    }
    
    final class Empty {}
    
    struct COWStruct {
        var ref = Empty()
        
        mutating func change() -> Bool {
            return isKnownUniquelyReferenced(&ref)
        }
    }
    
    func testTrapWriteInCopy() {
        var origin = COWStruct()
        XCTAssert(origin.change())
        let copy = origin
        XCTAssert(!origin.change())
        
        // 直接可获得写时复制优化 下标间接访问时会复制
        var array = [COWStruct()]
        XCTAssert(array[0].change())
        let x = array[0]
        XCTAssert(!array[0].change())
        
        // 字典下标会寻找并返回值 所以返回的是找到的值的复制
        var dic = ["key": COWStruct()]
        XCTAssert(!dic["key"]!.change())
    }
    
    func testSetStruct() {
        
        var result = CGSize.zero
        var size  = CGSize(width: 20, height: 20) {
            didSet {
                print("size changed: \(size)")
                result = size
            }
        }
        
        //改变结构体某个属性时didset也被触发
        size.width = 100;
        XCTAssert(result.width == 100)
        
        var resultArray: [CGSize] = []
        var array = [size] {
            didSet {
                resultArray = array
            }
        }
        array[0].height = 22.22
        XCTAssert(resultArray == [CGSize(width: 100, height: 22.22)])
        XCTAssert(size != resultArray.first)
    }
    
    func testMutable() {
        var mutableArray = [1,2,3]
        var num = 0
        for _ in mutableArray {
            num += 1
            mutableArray.removeLast()
        }
        // nsmutablearray不能再迭代的同时修改数组但是Array可以 因为Array是值类型迭代器持有数组独立的复制
        XCTAssert(num == 3)
        
        let _nsmutableArray: NSMutableArray = [1,2,3]
        let otherArray = _nsmutableArray
        _nsmutableArray.add(4)
        // 两个变量指向同一个变量 改变一个值另一个值同时被改变 不变性不再有效
        XCTAssert(otherArray == _nsmutableArray && otherArray == [1,2,3,4])
    }
    
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
