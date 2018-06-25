import Foundation
import XCTest
@testable import Hatching

class MockGenerator {
    let circles: [Circle]
    var idx: Int = 0
    var generated = 0
    let q = DispatchQueue(label: "MockGenerator")

    init(circles: [Circle]) {
        XCTAssertFalse(circles.isEmpty)
        self.circles = circles
    }

    func generate() -> Circle {
        let circle = circles[idx]
        idx += 1
        if idx == circles.count {
            idx = 0
        }
        q.sync {
            generated += 1
        }
        return circle
    }
}
