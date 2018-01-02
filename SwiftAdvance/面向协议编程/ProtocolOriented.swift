//
//  File.swift
//  SwiftAdvance
//
//  Created by ray on 2017/9/16.
//  Copyright © 2017年 ray. All rights reserved.
//


import Foundation

// MARK: - 参考地址https://chengwey.com/dang-swift-zhong-de-fan-xing-yu-dao-xie-yi/
protocol GenericProtocol {
    associatedtype AbstractType
    
    func magic() -> AbstractType
}

// error: Protocol 'GenericProtocol' can only be used as a generic constraint because it has Self or associated type requirements.
// 泛型协议不能当做类型使用
//let list: [GenericProtocol] = []

protocol NormalProtocol {
    func smile();
    var text: String { get }
}

let hehe: [NormalProtocol] = []

/// 使用 thunk 来解决在协议中缺少类型参数化
struct GenericProtocolThunk<T>: GenericProtocol {
    func magic() -> T {
        // any protocol methods are implemented by forwarding
        return _magic()
    }
    private let _magic: () -> T
    
    init<P: GenericProtocol>(_ dep: P) {
        _magic = dep.magic() as! () -> T
    }
}

struct StringMagic: GenericProtocol {
    func magic() -> String {
        return "Magic"
    }
}
/// 拥有一个 thunk，我们可以把他当做类型使用（需要我们自己提供具体的类型）
let magicians : [GenericProtocolThunk<String>] = [GenericProtocolThunk(StringMagic())]

