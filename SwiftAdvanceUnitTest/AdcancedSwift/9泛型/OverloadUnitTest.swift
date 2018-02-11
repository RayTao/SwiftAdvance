//
//  GenericUnitTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/11.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

/// Double的幂运算
func raise(_ base: Double, to exponent: Double) -> Double {
    return pow(base, exponent)
}
/// Float的幂运算
func raise(_ base: Float, to exponent: Float) -> Float {
    return powf(base, exponent)
}

func log<O: NSObject>(_ object: O) -> String {
    let des = "It's a \(type(of: object)) object"
    return des
}

func log<O: NSArray>(_ object: O) -> String {
    let des = "It's a array, array: \(object)"
    return des
}

/// 幂运算运算符重载
precedencegroup ExponentitationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator **: ExponentitationPrecedence

func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

func **(lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)
}

func **<I: SignedInteger>(lhs: I, rhs: I) -> I {
    let result = Double(Int(lhs)) ** Double(Int(rhs))
    return numericCast(Int(result))
}

extension Sequence where Iterator.Element: Hashable {
    /// 如果self的所有元素都包含在other中，则返回true
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence where Iterator.Element: Equatable {
    /// 如果self的所有元素都包含在other中，则返回true
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence {
    func isSubset<S: Sequence>(of other: S,
                               by areEquival: (Iterator.Element, S.Iterator.Element) -> Bool )
        -> Bool
    {
        for element in self {
            guard other.contains(where: {areEquival(element, $0) }) else {
                return false
            }
        }
        return true
    }
}



class OverloadUnitTest: XCTestCase {

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
    
    ///重载实在编译期间决定的，会按照变量的静态类型决定调用哪个重载
    func testFreeFuncOverload() {
        let double = raise(2.0, to: 3.0)
        let float: Float = raise(2.0, to: 3.0)
        XCTAssert(double as Any is Double)
        XCTAssert(float as Any is Float)
        
        XCTAssert(log(NSObject()) == "It's a NSObject object")
        XCTAssert(log(NSArray(array: [1]) ) == "It\'s a array, array: (\n    1\n)")
        
        let array = [NSObject(), NSArray(array: [1])]
        var result = ""
        for obj in array {
            result += log(obj)
        }
        // 因为array是[NSObject]类型 所以调用log<O: NSObject>
        XCTAssert(result == "It\'s a NSObject objectIt\'s a __NSSingleObjectArrayI object")
        
    }

    func testOperatorOverload() {
        // 报错 Ambiguous use of operator
//        let result = 2 ** 3
        let intResult: Int = 2 ** 3
        XCTAssert(intResult == 8)
    }
    
    func testGenericOverload() {
        XCTAssert([5,4,3].isSubset(of: 1...10))
        
        let ints = [1,2]
        let strings = ["1","2","3"]
        XCTAssert(ints.isSubset(of: strings) { String($0) == $1 })
    }
    
    
}
