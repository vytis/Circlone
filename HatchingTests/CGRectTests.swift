import XCTest
@testable import Hatching

class CGRectTests: XCTestCase {
    
    let first = CGRect(x: 0, y: 0, width: 100, height: 100)
    let second = CGRect(x: 12, y: 22, width: 33, height: 99)
    
    func testLeftSide() {
        XCTAssertEqual(first.leftSide, CGRect(x: 0, y: 0, width: 50, height: 100))
        XCTAssertEqual(second.leftSide, CGRect(x: 12, y: 22, width: 16.5, height: 99))
    }
    
    func testRightSide() {
        XCTAssertEqual(first.rightSide, CGRect(x: 50, y: 0, width: 50, height: 100))
        XCTAssertEqual(second.rightSide, CGRect(x: 28.5, y: 22, width: 16.5, height: 99))
    }    
}
