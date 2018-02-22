//
//  IndexSearch.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/22.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

/// swift4 已经支持以下约束
//SubSequence.Iterator.Element == Iterator.Element,
//Indices.Iterator.Element == Index
extension Collection
    where Iterator.Element: Equatable
//    SubSequence.Iterator.Element == Iterator.Element,
//    Indices.Iterator.Element == Index
{
    func search<Other: Sequence>(for pattern: Other) -> Index?
        where Other.Iterator.Element == Iterator.Element
    {
        return indices.first { idx in
            suffix(from: idx).starts(with: pattern)
        }
    }
    
}

extension RandomAccessCollection
    where Iterator.Element: Equatable
{
    func search<Other: RandomAccessCollection>(for pattern: Other) -> Index?
        where Other.IndexDistance == IndexDistance,
        Other.Iterator.Element == Iterator.Element
    {
        //判断长度
        guard !isEmpty && pattern.count <= count else { return nil }
        
        //从起始索引到满足匹配模式的最后一个索引
        let stopSearchIndex = index(endIndex, offsetBy: -pattern.count)
        
        return prefix(upTo: stopSearchIndex).indices.first { idx in
            suffix(from: idx).starts(with: pattern)
        }
    }
}


