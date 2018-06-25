import XCTest
@testable import Hatching

class StorageTests: XCTestCase {

    var storage: Storage!

    override func setUp() {
        super.setUp()
        storage = Storage(viewport: Viewport(height: 100, width: 100))
    }

    override func tearDown() {
        storage = nil
        super.tearDown()
    }

    func testAddingCircleToEmptyStorage() {
        let items = [one]
        let added = storage.add(items)
        XCTAssertEqual(added, items)
        XCTAssertEqual(storage.all, items)
    }

    func testThatProgressCallbackIsCalledWithStorageSize() {
        let items = [one, four]

        let expectation = self.expectation(description: "Progress")
        expectation.expectedFulfillmentCount = items.count

        var countsReported = [Int]()
        _ = storage.add(items) { count in
            countsReported.append(count)
            expectation.fulfill()
        }
        
        XCTAssertEqual(countsReported, Array(1...items.count))
        waitForExpectations(timeout: 0.5)
    }

    func testThatItAddsOnlyCirclesThatDoNotCollide() {
        let items = [one, two, three, four]
        let added = storage.add(items)

        XCTAssertEqual(added, [one, two])
    }

    func testRemovingCircleAtPoint() {
        _ = storage.add([one])
        let removed = storage.popItemAt(x: 3, y: 3)
        XCTAssertEqual(removed, one)
    }

    func testNotRemovingCircleAtPoint() {
        _ = storage.add([one])
        let removed = storage.popItemAt(x: 5, y: 5)
        XCTAssertNil(removed)
    }

}
