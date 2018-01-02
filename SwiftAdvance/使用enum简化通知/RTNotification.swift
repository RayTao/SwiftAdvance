//
//  RTNotification.swift
//  SwiftAdvance
//
//  Created by ray on 2017/8/3.
//  Copyright © 2017年 ray. All rights reserved.
//

import Foundation

/// 先声明一个rawValue为字符串的枚举。为了规避命名的冲突，声明一个计算属性，
/// 在每个值的rawValue前插入一个字符串。再用这个字符串去生成NSNotification.Name：

enum RTNotification: String {
    case userLogin
    case userLogout
    
    
    var stringValue: String {
        return "RT" + rawValue
    }
    
    var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }
}

extension NotificationCenter {
    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: RTNotification, object anObject: Any?)
    {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName.notificationName, object: anObject)
        
    }

    
    static func post(customNotification name: RTNotification,
                     object: Any? = nil,
                     userInfo aUserInfo: [AnyHashable : Any]? = nil)
    {
        NotificationCenter.default.post(name: name.notificationName, object: object, userInfo: aUserInfo)
    }
}
