//
//  File.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/22.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

let funcAText = "funcA"
let funcBText = "funcB"
let funcCText = "funcC"
let simpleText = "struct"

protocol TestProtocol {
    func funcA() -> String
    func funcB() -> String
}

extension TestProtocol {
    func funcB() -> String {
        return funcBText
    }
}

extension TestProtocol {
    func funcC() -> String {
        return funcCText
    }
}

struct ProtocolSimple: TestProtocol {
    let text = simpleText
    
    func funcA() -> String {
        return text + funcAText
    }
    
    func funcB() -> String {
        return text + funcBText
    }
    
    func funcC() -> String {
        return text + funcCText
    }
}

/// 简单的类型抹消
/// 创建AnyProtocolName结构体或者类。然后对每个关联类型添加一个泛型参数
/// 最后对每个方法实现储存在AnyProtocolName的一个属性中
/// 但是对于复杂的协议需要添加多个闭包与协议方法一一对应
struct AnyProtocolIterator<A>: IteratorProtocol {
    var nextImpl: () -> A?
    
    init<I: IteratorProtocol>(_ iterator: I) where I.Element == A {
        var iteratorCopy = iterator
        self.nextImpl = { iteratorCopy.next() }
    }
    
    func next() -> A? {
        return nextImpl()
    }
}




