//
//  BinarySearch.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/11.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation


extension Array {
    
    /// 数组的二分查找算法 复杂度是O(log count) 要求：是在self中元素上的严格弱序，且数组中元素已经按它进行过排序
    ///
    /// - Parameters:
    ///   - value: 搜索的值
    ///   - areInIncreasingOrder: 是否按照升序或者降序排列
    /// - Returns: 返回value第一次出现在self中的索引值，如果value不存在 返回nil
    public func binarySearch(for value: Element,
                             areInIncreasingOrder: (Element, Element) -> Bool)
        -> Int?
    {
        guard !isEmpty else {
            return nil
        }
        var left = 0
        var right = count - 1
        
        while left <= right {
            let mid = (left + right) / 2
            let candidate = self[mid]
            
            if areInIncreasingOrder(candidate, value) {
                left = mid + 1
            } else if areInIncreasingOrder(value, candidate) {
                right = mid + 1
            } else {
                // 由于 isOrderedBefore 的要求
                // 如果两个元素无互相无顺序关系 它们一定相等
                return mid
            }
        }
        
        return nil
    }

}

extension Array where Element: Comparable {
    func binarySearch(for value: Element) -> Int? {
        return self.binarySearch(for: value, areInIncreasingOrder: <)
    }
}


extension RandomAccessCollection {
    public func binarySearch(for value: Iterator.Element,
                             areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool)
        -> Index?
    {
        
        guard !isEmpty else {
            return nil
        }
        var left = startIndex
        var right = index(before: endIndex)
        
        while left <= right {
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]
            
            if areInIncreasingOrder(candidate, value) {
                left = index(after: mid)
            } else if areInIncreasingOrder(value, candidate) {
                right = index(before: mid)
            } else {
                // 由于 isOrderedBefore 的要求
                // 如果两个元素无互相无顺序关系 它们一定相等
                return mid
            }
        }
        
        return nil
    }
    
}

extension RandomAccessCollection
    where Iterator.Element: Comparable
{
    func binarySearch(for value: Iterator.Element) -> Index? {
        return binarySearch(for: value, areInIncreasingOrder: <)
    }
    
}

