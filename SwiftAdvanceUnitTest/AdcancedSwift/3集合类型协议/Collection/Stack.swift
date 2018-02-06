//
//  Stack.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/6.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

protocol Stack {
    /// 栈中的元素类型
    associatedtype Element
    
    /// 将x入栈到self作为栈顶元素
    /// - 复杂度 O(1)
    mutating func push(_ x: Element)
    
    /// 从self移除栈顶元素, 并返回它
    /// 如果self是空 返回nil
    /// - 复杂度 O(1)
    mutating func pop() -> Element?
    
}
