//
//  MutiProtocol.swift
//  SwiftAdvance
//
//  Created by ray on 2017/9/30.
//  Copyright © 2017年 ray. All rights reserved.
//

import Foundation

protocol AProtocol {
    func methodA() -> String
}

extension AProtocol {
//    func methodA() -> String {
//        return "AProtocol.methodA"
//    }
}

protocol BProtocol {
    func methodA() -> String
}

extension BProtocol {
    func methodA() -> String {
        return "BProtocol.methodA"
    }
}

class MutiProtocolClass: AProtocol, BProtocol {
    func test() {
        print((self as AProtocol).methodA())
        print(methodA())
    }
    
//    func methodA() -> String {
//        return "MutiProtocolClass.methodA"
//    }
}
