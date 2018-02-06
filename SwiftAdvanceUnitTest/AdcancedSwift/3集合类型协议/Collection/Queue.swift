//
//  Queue.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/3.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation


/// 一个能将元素入队和出队的类型
protocol Queue {
    /// self中持有的元素类型
    associatedtype Element
    /// 将newElement入队到self
    mutating func enqueue(_ newElement: Element)
    /// self出队一个元素
    mutating func dequeue() -> Element?
    
}

/// 定义一个队列 实现自己的集合
struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    /// 复杂度O(1)
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    /// 复杂度 平均 O(1)
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
    
    /// 提供Indices类型,让它不需要保持对集合的引用,可以提升性能。
    /// 计算索引不依赖集合本身的集合类型都是有效的，索引是整数型的可以直接使用CountableRange<Index>
    typealias Indices = CountableRange<Int>
    var indices: CountableRange<Int> {
        return startIndex..<endIndex
    }
    
}

extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(left: elements.reversed(), right: [])
    }
}
