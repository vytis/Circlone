//
//  CircleTests.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import XCTest
@testable import Hatching

class CircleTests: XCTestCase {
    
    let one = Circle(x: 1, y: 2, radius: 3)
    let two = Circle(x: 2, y: 3, radius: 4)
    let three = Circle(x: 2, y: 3, radius: 6)
    let four = Circle(x: 5, y: 8, radius: 3)
    
    func testCircleEqualWhenAllValuesAreEqual() {
        XCTAssertEqual(one, one)
        XCTAssertNotEqual(one, two)
        XCTAssertNotEqual(two, three)
    }
    
    func testCircleIsBiggerWhenRadiusIsBigger() {
        XCTAssertLessThan(one, two)
        XCTAssertLessThan(two, three)
        XCTAssertLessThan(one, three)
        XCTAssertLessThanOrEqual(one, one)
    }
    
    func testContainsPointWhenPointIsInside() {
        XCTAssertTrue(one.containsPoint(x: 1, y: 2))
        XCTAssertTrue(one.containsPoint(x: 2, y: 3))
        XCTAssertFalse(one.containsPoint(x: 4, y: 5))
    }
    
    func testCollidesWhenThereIsOverlappingArea() {
        XCTAssertTrue(one.collides(one))
        XCTAssertTrue(one.collides(two))
        XCTAssertFalse(one.collides(four))
    }
    
    func testCollidesWhenAtLeastOneCircleCollides() {
        XCTAssertTrue(one.collides([two, four]))
        XCTAssertFalse(one.collides([four, four]))
    }
}
