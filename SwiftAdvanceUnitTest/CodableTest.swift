//
//  CodableTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/2/7.
//  Copyright © 2018年 ray. All rights reserved.
//

import XCTest

extension Decodable {
    
    static func object(jsonString: String,
                       dateStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate) -> Self? {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = dateStrategy
            let object = try jsonDecoder.decode(Self.self, from: jsonString.data(using: .utf8)!)
            return object
        } catch {
            // 异常处理
//            let des = error.localizedDescription
//            assert(true, des)
            return nil
        }
    }
    
}


class CodableTest: XCTestCase {

    struct Student: Decodable {
        var name: String
        var age: Int
        var weight: Float
        var gender: Gender?
        var isYoungPioneer: Bool
        var nickName: String?
        var birthday: Date?
        var school: School?

        enum CodingKeys: String, CodingKey {
            case name
            case age
            case weight
            case birthday = "birth_date"
            case gender
            case isYoungPioneer
            case nickName
            case school
        }
    }
    
    struct School: Decodable {
        var name: String
        var address: String
    }
    
    /// 枚举类型要默认支持 Codable 协议，需要声明为具有原始值的形式，并且原始值的类型需要支持 Codable 协议：
    /// 由于枚举类型原始值隐式赋值特性的存在，如果枚举值的名称和对应的 JSON 中的值一致，不需要显式指定原始值即可完成解析
    enum Gender: String, Decodable {
        case male
        case female
        case other
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    let student = ["name": "小明",
                   "age": 12,
                   "weight": 43.2,
                   "gender": "male",
                   "isYoungPioneer": true,
                   "school": [
                    "name": "市第一中学",
                    "address": "XX市人民中路 66 号"]
        ] as [String : Any]
    
    func testDecodabel() {
        let jsonString = """
{
 
   "name": "小明",
    "age": 12,
    "weight": 43.2,
    "gender": "male",
    "isYoungPioneer": true,
    "school": {
          "name": "市第一中学",
          "address": "XX市人民中路 66 号"
        },

}
"""
        let xiaoming = Student.object(jsonString: jsonString)!
        XCTAssert(xiaoming.name == "小明")
        XCTAssert(xiaoming.age == 12)
        XCTAssert(xiaoming.weight == 43.2)
//        XCTAssert(xiaoming.gender == .male)
        XCTAssert(xiaoming.isYoungPioneer == true)
        XCTAssert(xiaoming.school?.name == "市第一中学")
        XCTAssert(xiaoming.school?.address == "XX市人民中路 66 号")
    }
    
    /// Bool 类型默认只支持 true/false 形式的 Bool 值解析。对于一些使用 0/1 形式来表示 Bool 值的后端框
    /// 架，只能通过 Int 类型解析之后再做转换了，或者可以自定义实现 Codable 协议。
    func testBoolDecode() {
        let jsonString = """
{
 
   "name": "小明",
    "age": 12,
    "weight": 43.2,
    "gender": "male",
    "isYoungPioneer": 1,

}
"""
        let xiaoming = Student.object(jsonString: jsonString)
        XCTAssert(xiaoming == nil)

    }
    
    func testEnum() {
        var jsonString = """
{
 
   "name": "小明",
    "age": 12,
    "weight": 43.2,
    "gender": "male",
    "isYoungPioneer": true,

}
"""
        let xiaoming = Student.object(jsonString: jsonString)!
        XCTAssert(xiaoming.gender == .male)
        
        jsonString = """
{
 
   "name": "小明",
    "age": 12,
    "weight": 43.2,
    "gender": "haha",
    "isYoungPioneer": true,

}
"""
        let hah = Student.object(jsonString: jsonString)
        XCTAssert(hah == nil)
        
    }
    
    /// JSONDecoder 类声明了一个 DateDecodingStrategy 类型的属性，用来制定 Date 类型的解析策略 默认.deferredToDate
    /// date时区也是美国时区比中国慢13小时 所以建议通过 Float 类型解析之后再做转换了，或者可以自定义实现 Codable 协议。
    func testDate() {
        let jsonString = """
{
 
   "name": "小明",
    "age": 12,
    "weight": 43.2,
    "gender": "male",
    "isYoungPioneer": true,
    "birth_date": 519751611.125429
}
"""
        let xiaoming = Student.object(jsonString: jsonString)!
        guard let birthday = xiaoming.birthday else {
            XCTAssertFalse(true)
            return
        }
        XCTAssert(birthday.description.contains("2017-06-21"))
    
        guard let birthday2 = Student.object(jsonString: jsonString, dateStrategy: .secondsSince1970)?.birthday  else {
            XCTAssertFalse(true)
            return
        }
        XCTAssert(birthday > birthday2)
        XCTAssert(birthday2.description.contains("1986-06-21"))

        
        
    }
    
    /// Codable 通过巧（kai）妙（guà）的方式，在编译代码时根据类型的属性，自动生成了一个 CodingKeys 的枚举类型定义，这是一个以
    /// String 类型作为原始值的枚举类型，对应每一个属性的名称。然后再给每一个声明实现 Codable 协议的类型自动生成 init(from:)
    /// 和 encode(to:) 两个函数的具体实现，最终完成了整个协议的实现。
    /// 需要注意的是，即使属性名称与 JSON 中的字段名称一致，如果自定义了 CodingKeys，这些属性也是无法省略的，否则会得到的编译错误
    func testCustomCodeingKeys() {
        var jsonString = """
{
 
   "name": "小明",
    "age": 12,
    "weight": 43.2,
    "gender": "male",
    "isYoungPioneer": true,
    "birth_date": 519751611.125429
}
"""
        let xiaoming = Student.object(jsonString: jsonString)!
        XCTAssert(xiaoming.birthday != nil)
        
        jsonString = """
        {
        
        "name": "小明",
        "age": 12,
        "weight": 43.2,
        "gender": "male",
        "isYoungPioneer": true,
        "birthday": 519751611.125429
        }
        """
        XCTAssert(Student.object(jsonString: jsonString)!.birthday == nil)
    }
    
    func testArray() {
        
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
