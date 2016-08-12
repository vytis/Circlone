//
//  CGRectTests.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import XCTest
@testable import Hatching

class CGRectTests: XCTestCase {
    
    let one = CGRect(x: 0, y: 0, width: 100, height: 100)
    let two = CGRect(x: 12, y: 22, width: 33, height: 99)
    
    func testLeftSide() {
        XCTAssertEqual(one.leftSide, CGRect(x: 0, y: 0, width: 50, height: 100))
        XCTAssertEqual(two.leftSide, CGRect(x: 12, y: 22, width: 16.5, height: 99))
    }
    
    func testRightSide() {
        XCTAssertEqual(one.rightSide, CGRect(x: 50, y: 0, width: 50, height: 100))
        XCTAssertEqual(two.rightSide, CGRect(x: 28.5, y: 22, width: 16.5, height: 99))
    }    
}
