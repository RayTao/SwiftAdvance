//
//  ThreadTest.swift
//  SwiftAdvance
//
//  Created by ray on 2018/3/17.
//  Copyright © 2018年 ray. All rights reserved.
//

import Foundation

/// 多线程环境下静态变量、实例变量和局部变量的一点点研究
class ThreadTest {
    static var num = 0
    var num = 0
    
    /// 静态变量也称为类变量，属于类对象所有，位于方法区，为所有对象共享，共享一份内存，一旦值被修改，则其他对象均对修改可见，故线程非安全
    @objc func run() {
        ThreadTest.num = 3
        print("当前线程:" + Thread.current.name! + ", num:" + String(ThreadTest.num))
        
        ThreadTest.num = 5
        print("当前线程:" + Thread.current.name! + ", num:" + String(ThreadTest.num * 2))
        
    }
 
    ///结论：每个线程执行时都会把局部变量放在各自的帧栈的内存空间中，线程间不共享，故不存在线程安全问题。
    @objc func runLocal() {
        var num = 2
        print("当前线程:" + Thread.current.name! + ", num:" + String(num))
        
        num = 5
        print("当前线程:" + Thread.current.name! + ", num:" + String(num * 2))
        
    }
    
    ///结论：实例变量是实例对象私有的，系统只存在一个实例对象，则在多线程环境下，如果值改变后，则其它对象均可见，故线程非安全；
    ///如果每个线程都在不同的实例对象中执行，
    ///则对象与对象间的修改互不影响，故线程安全。
    @objc func runObjectVar() {
        num = 2
        print("当前线程:" + Thread.current.name! + ", num:" + String(num))
        
        num = 6
        print("当前线程:" + Thread.current.name! + ", num:" + String(num * 3))
    }
}

func TestStaticVar() {
    
    let thread1 = ThreadTest()
    for i in 1...10 {
        let testThread = Thread(target: thread1, selector: #selector(ThreadTest.run), object: nil)
        testThread.name = String(i)
        testThread.start()
    }
}

func TestLocalVar() {
    
    let thread1 = ThreadTest()
    for i in 1...20 {
        let testThread = Thread(target: thread1, selector: #selector(ThreadTest.runLocal), object: nil)
        testThread.name = String(i)
        testThread.start()
    }
}

func TestObjectVar() {
    
    let thread1 = ThreadTest()
    for i in 11...30 {
        let testThread = Thread(target: thread1, selector: #selector(ThreadTest.runObjectVar), object: nil)
        testThread.name = String(i)
        testThread.start()
    }
    
    for i in 31...50 {
        let testThread = Thread(target: ThreadTest(), selector: #selector(ThreadTest.runObjectVar), object: nil)
        testThread.name = String(i)
        testThread.start()
    }
}

