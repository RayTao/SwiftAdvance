//
//  MostFrequence.swift
//  SwiftAdvance
//
//  Created by ray on 2018/3/20.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

public class MostFrequence {
    /// 输入字符串输出: 按出现频率从高到低的a-z的小写字符
    public class func mostFrequence(s: String) -> String {
        var result = s.lowercased()
        var dic: [String: Int] = [:]
        let set =
            CharacterSet(["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"])
        result.enumerateSubstrings(in: s.range(of: s)!, options: .byComposedCharacterSequences) { (subString, _, _, _) in
            guard let key = subString else { return }
            
            if key.trimmingCharacters(in: set).isEmpty {
                let repeatCount = dic[key]
                if repeatCount == nil {
                    dic[key] = 1
                } else {
                    dic[key] = repeatCount! + 1
                }
            }
        }
        
        let sortedArray =
        dic.keys.sorted { (objectA, objectB) -> Bool in
            let repeatCountA = dic[objectA]!
            let repeatCountB = dic[objectB]!
            if repeatCountA > repeatCountB {
                return true
            } else if repeatCountB > repeatCountA {
                return false
            } else {
                return objectA < objectB
            }
        }
        
        result = ""
        for object in sortedArray {
            result.append(object)
        }
        return result
    }
    
}
