//
//  PrefixIterator.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/10.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

struct PrefixIterator<Base: Collection>: IteratorProtocol, Sequence {
    let base: Base
    var offset: Base.Index
    
    init(_ base: Base) {
        self.base = base
        self.offset = base.startIndex
    }
    
    mutating func next() -> Base.SubSequence? {
        guard offset != base.endIndex else { return nil }
        base.formIndex(after: &offset)
        return base.prefix(upTo: offset)
    }
    
}
