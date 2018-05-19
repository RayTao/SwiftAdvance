//
//  DispatchTimeEx.swift
//  SwiftAdvance
//
//  Created by ray on 2018/3/27.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
