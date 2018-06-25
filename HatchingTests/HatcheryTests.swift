import XCTest
@testable import Hatching

class HatcheryTests: XCTestCase {

    var hatchery: Hatchery!
    var generator: MockGenerator!

    override func setUp() {
        super.setUp()
        generator = MockGenerator(circles: [one, two, three, four])
        hatchery = Hatchery(viewport: Viewport(height: 100, width: 100), maxSize: 100, generate: generator.generate)
    }

    override func tearDown() {
        hatchery?.stop()
        hatchery = nil
        super.tearDown()
    }

    func testThatHatcheryGetsReleasedAfterInit() {
        weak var old = hatchery
        hatchery = nil
        XCTAssertNil(old)
    }

    func testThatHatcheryStartsNotRunning() {
        XCTAssertFalse(hatchery.running)
    }

    func testThatHatcheryCanBeStartedAndStopped() {
        hatchery.start()
        XCTAssertTrue(hatchery.running)
        hatchery.stop()
        XCTAssertFalse(hatchery.running)
    }

    func testThatItGeneratesCirclesAfterStart() {
        hatchery.start()
        let events = hatchery.consumeEvents()
        XCTAssertTrue(generator.generated > 0)
        XCTAssertFalse(hatchery.allCircles.isEmpty)
        XCTAssertFalse(events.isEmpty)
    }

    func testThatItDoesNotGenerateMoreCirclesAfterStop() {
        hatchery.start()
        _ = hatchery.consumeEvents()
        hatchery.stop()
        let generated = generator.generated
        let events = hatchery.consumeEvents()
        XCTAssertTrue(events.isEmpty)
        XCTAssertEqual(generated, generator.generated)
    }

    func testThatItRemovesACircleAtPoint() {
        hatchery.start()
        hatchery.removeCircleAt(x: 3, y: 3)
        let events = hatchery.consumeEvents()
        XCTAssertTrue(events.contains(.removed(one)))
    }
}
