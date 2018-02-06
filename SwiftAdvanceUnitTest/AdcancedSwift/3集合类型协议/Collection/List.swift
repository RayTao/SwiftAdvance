//
//  List.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/3.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

public struct List<Element>: Collection {
    
    public typealias Index = ListIndex<Element>
    
    public var startIndex: Index
    public let endIndex: Index
    
    public subscript(position: Index) -> Element {
        switch position.node {
            
        case .end:
            fatalError("subscript out of rang")
        case let .node(x, _): return x
            
        }
    }
    
    public func index(after idx: Index) -> Index {
        switch idx.node {
        case .end:             fatalError("subscript out of rang")
        case let .node(_, next): return Index(node: next, tag: idx.tag - 1)
            
        }
    }
}

extension List {
    public var count: Int  {
        return startIndex.tag - endIndex.tag
    }
    
    func cons(_ x: Element) -> List {
        
        let startIndex = ListIndex(node: self.startIndex.node.cons(x), tag: self.count + 1)
        let endIndex = ListIndex(node: ListNode<Element>.end, tag: 0)

        return List(startIndex: startIndex, endIndex: endIndex)
    }
}

extension List: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
//        self = elements.reversed().reduce(.end) { partialList, element in
//            partialList.cons(element)
//        }
        startIndex = ListIndex(node: elements.reversed().reduce(.end){
            partialList, element in
            partialList.cons(element)
        }, tag: elements.count)
        
        endIndex = ListIndex(node: .end, tag: 0)
    }
    
}

extension List: Stack {

    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
    mutating func pop() -> Element? {
        if self.count == 0 {
            return nil
        } else {
            switch self.startIndex.node {
            case .end: return nil
            case let .node(x, next):
                let startIndex = ListIndex(node: next, tag: self.count - 1)
                self.startIndex = startIndex
                return x
            }
        }
    }
}

/// 含有约束的List类型不能拥有继承语句关系
//extension List: Equatable where Element: Equatable {}

extension List: IteratorProtocol, Sequence {
    public mutating func next() -> Element? {
        return pop()
    }
}

extension List: CustomStringConvertible {
    public var description: String {
        let element = self.map { String(describing: $0) }.joined(separator: ", ")
        return "List: (\(element))"
    }
    
    
}

fileprivate enum ListNode<Element> {
    case end
    indirect case node(Element, next: ListNode<Element>)
    
    func cons(_ x: Element) -> ListNode<Element> {
        return .node(x, next: self)
    }
}

public struct ListIndex<Element>: CustomStringConvertible {
    fileprivate var node: ListNode<Element>
    fileprivate let tag: Int
    
    public var description: String {
        return "ListIndex(\(tag))"
    }
}

extension ListIndex: Comparable {
    public static func < <T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        // startIndex 的 tag值最大，endIndex最小
        return lhs.tag > rhs.tag
    }
    
    public static func == <T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
}

//public struct List<Element>




