import Foundation
import XCTest
@testable import Hatching

extension XCTestCase {
    var insideCircle: Circle {
        return Circle(x: 5, y: 5, radius: 2)
    }

    var outsideCircle: Circle {
        return Circle(x: 100, y: 100, radius: 5)
    }

    var one: Circle {
        return Circle(x: 2, y: 2, radius: 2)
    }

    var two: Circle {
        return Circle(x: 6, y: 6, radius: 2)
    }

    var three: Circle {
        return Circle(x: 2, y: 3, radius: 6)
    }

    var four: Circle {
        return Circle(x: 5, y: 8, radius: 3)
    }

    var frame: CGRect {
        return CGRect(x: 0, y: 0, width: 10, height: 10)
    }
}
