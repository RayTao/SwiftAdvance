//
//  FisherYates.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/12.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

/// 随机排列
extension Array {
    /// 洗牌算法
    mutating func shuffle() {
        for i in 0..<(count-1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            
            //保证不会将一个元素与自己交换
            guard i != j else { continue }
            
            swapAt(i, j)
        }
    }
    
    /// shuffle的不可变版本
    func shuffled() -> [Element] {
        var clone = self
        clone.shuffle()
        return clone
    }
}

extension SignedInteger {
    static func arc4random_uniform(_ upper_bound: Self) -> Self {
        precondition(upper_bound > 0 &&
        Int(upper_bound) < Int(UInt32.max),
                     "arc4random_uniform only callable up to \(UInt32.max)")
                     
        return numericCast(Darwin.arc4random_uniform(numericCast(upper_bound)))
        
    }
    
}

extension MutableCollection where Self: RandomAccessCollection {
    mutating func shuffle() {
        var i = startIndex
        let beforeEndIndex = index(before: endIndex)
        while i < beforeEndIndex {
            let dist = distance(from: i, to: endIndex)
            let randomDistance = arc4random_uniform(UInt32(dist))
            let j = index(i, offsetBy: Int(randomDistance))
            guard i != j else { continue }
            swapAt(i, j)
            formIndex(after: &i)
        }
    }
}

extension MutableCollection
    where Self: RandomAccessCollection,
    Self: RangeReplaceableCollection
{
    func shuffled() -> Self {
        var clone = Self()
        clone.append(contentsOf: self)
        clone.shuffle()
        return clone
    }
}

extension Sequence {
    func shuffled() -> [Iterator.Element] {
        var clone = Array(self)
        clone.shuffle()
        return clone
    }
}





