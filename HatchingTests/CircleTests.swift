import XCTest
@testable import Hatching

class CircleTests: XCTestCase {
    
    func testCircleEqualWhenAllValuesAreEqual() {
        XCTAssertEqual(one, one)
        XCTAssertNotEqual(one, two)
        XCTAssertNotEqual(two, three)
    }
    
    func testCircleIsBiggerWhenRadiusIsBigger() {
        XCTAssertLessThan(one, three)
        XCTAssertLessThan(two, three)
        XCTAssertLessThanOrEqual(one, one)
    }
    
    func testContainsPointWhenPointIsInside() {
        XCTAssertTrue(one.containsPoint(x: 1, y: 2))
        XCTAssertTrue(one.containsPoint(x: 2, y: 3))
        XCTAssertFalse(one.containsPoint(x: 4, y: 5))
    }
    
    func testCollidesWhenThereIsOverlappingArea() {
        XCTAssertTrue(one.collides(one))
        XCTAssertTrue(one.collides(three))
        XCTAssertFalse(one.collides(two))
    }
    
    func testCollidesWhenAtLeastOneCircleCollides() {
        XCTAssertTrue(one.collides([two, three]))
        XCTAssertFalse(one.collides([two, four]))
    }
}
