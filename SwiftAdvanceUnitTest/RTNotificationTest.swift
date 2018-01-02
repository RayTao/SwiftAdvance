//
//  RTNotificationTest.swift
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2017/8/3.
//  Copyright © 2017年 ray. All rights reserved.
//

import XCTest

class RTNotificationTest: XCTestCase {
    var notificationName = ""
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NotificationCenter.addObserver(self, selector: #selector(handlerNotification(notification:)), name: .userLogin, object: nil)
        NotificationCenter.addObserver(self, selector: #selector(handlerNotification(notification:)), name: .userLogout, object: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoginNotification() {
        NotificationCenter.post(customNotification: .userLogin)
        XCTAssertEqual(RTNotification.userLogin.stringValue, notificationName)
    }
    
    func testLoginoutNotification() {
        
        NotificationCenter.post(customNotification: .userLogout)
        XCTAssertEqual(RTNotification.userLogout.stringValue, notificationName)
    }

    @objc func handlerNotification(notification: NSNotification) {
        notificationName = notification.name.rawValue
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
