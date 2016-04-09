//
//  TreeTests.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import XCTest
@testable import Circlone

class TreeTests: XCTestCase {
    
    func testNodeAddsOnlyIntersectingCircles() {
        let insideCircle = Circle(x: 5, y: 5, radius: 2)
        let outsideCircle = Circle(x: 100, y: 100, radius: 5)
        let node = Node(circles: [insideCircle, outsideCircle], frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        switch node.contents {
        case .Circles(let circles, _):
            XCTAssertEqual(circles, [insideCircle])
        case .Deeper:
            XCTFail()
        }
    }
    
    func testSplitNode() {
        let left = Circle(x: 2, y: 5, radius: 1)
        let middle = Circle(x: 5, y: 5, radius: 5)
        let right = Circle(x: 8, y: 5, radius: 1)
        let nodes = Node.split(circles: [left, middle, right], frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let leftNode = nodes[0]
        switch leftNode.contents {
        case .Circles(let circles, _):
            XCTAssertEqual(circles, [left, middle])
        case .Deeper:
            XCTFail()
        }

        let rightNode = nodes[0]
        switch rightNode.contents {
        case .Circles(let circles, _):
            XCTAssertEqual(circles, [right, middle])
        case .Deeper:
            XCTFail()
        }
    }
    
}
