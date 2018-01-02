//
//  MediaTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2017/8/17.
//  Copyright © 2017年 ray. All rights reserved.
//

import XCTest

class MediaTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIfCase() {
        let title = "Captain America: Civil War"
        let m = Media.movie(title: title, director: "Russo Brothers", year: 2016)
        // 对比switch case语法 更简洁
        if case let Media.movie(ptitle, _, _) = m {
            XCTAssert(title == ptitle)
        }
        /*switch m {
         case let Media.Movie(title, _, _):
         print("This is a movie named \(title)")
         default: () // do nothing, but this is mandatory as all switch in Swift must be exhaustive
         }*/
    }
    
    func testIfCaseWhere() {
        let title = "Captain America: Civil War"
        let m = Media.movie(title: title, director: "Russo Brothers", year: 2016)
        // 这种方式可以组合成一个相当强大的表达式，而改用 switch 实现可能会变得非常复杂，需要写很多行代码来检测那一个特定的 case。
        if case let Media.movie(_, _, year) = m, year < 1888 {
            XCTAssert(year == 2016)
        }

    }
    
    func testForCase() {
        let webUrl = "https://en.wikipedia.org/wiki/List_of_Harry_Potter-related_topics";
        let mediaList: [Media] = [
            .book(title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", year: 1997),
            .movie(title: "Harry Potter and the Philosopher's Stone", director: "Chris Columbus", year: 2001),
            .book(title: "Harry Potter and the Chamber of Secrets", author: "J.K. Rowling", year: 1999),
            .movie(title: "Harry Potter and the Chamber of Secrets", director: "Chris Columbus", year: 2002),
            .book(title: "Harry Potter and the Prisoner of Azkaban", author: "J.K. Rowling", year: 1999),
            .movie(title: "Harry Potter and the Prisoner of Azkaban", director: "Alfonso Cuarón", year: 2004),
            .movie(title: "J.K. Rowling: A Year in the Life", director: "James Runcie", year: 2007),
            .webSite(urlString: webUrl)
        ]
        
        for case let Media.webSite(urlString) in mediaList {
            XCTAssert(webUrl == urlString)
        }
        
        for case let Media.movie(_, director, year) in mediaList
            where director == "Chris Columbus" && year == 2001 {
            
                XCTAssert(true)
                return
        }
        
        XCTAssert(false)
    }

    func testCombine() {
        let webUrl = "https://en.wikipedia.org/wiki/List_of_Harry_Potter-related_topics";
        let mediaList: [Media] = [
            .book(title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", year: 1997),
            .movie(title: "Harry Potter and the Philosopher's Stone", director: "Chris Columbus", year: 2001),
            .book(title: "Harry Potter and the Chamber of Secrets", author: "J.K. Rowling", year: 1999),
            .movie(title: "Harry Potter and the Chamber of Secrets", director: "Chris Columbus", year: 2002),
            .book(title: "Harry Potter and the Prisoner of Azkaban", author: "J.K. Rowling", year: 1999),
            .movie(title: "Harry Potter and the Prisoner of Azkaban", director: "Alfonso Cuarón", year: 2004),
            .movie(title: "J.K. Rowling: A Year in the Life", director: "James Runcie", year: 2007),
            .webSite(urlString: webUrl)
        ]
        
        for case let (title?, kind) in mediaList.map({ ($0.title, $0.kind) })
            where title.hasPrefix("Harry Potter") && kind == "book" {
                XCTAssert(title.hasPrefix("Harry Potter and the"))
        }
    }
    
//    func testGuideCase() {
//        let response = NetworkResponse.response(response: URLResponse(), data: NSData())
//        _ = NetworkResponse.error(error: NSError(domain: "11", code: 0, userInfo: nil))
//        guard case let .response(urlResp, _) = response,
//            let httpResp = urlResp as? HTTPURLResponse, 200..<300 ~= httpResp.statusCode else {
//                XCTAssert(false)
//                return
//        }
//        XCTAssert(false)
//        if (true || false) {}
//    }
    
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
