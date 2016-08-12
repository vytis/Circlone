//
//  TreeTests.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import XCTest
@testable import Circlone
@testable import Hatching

class TreeTests: XCTestCase {
    
    func testNodeAddsOnlyIntersectingCircles() {
        let insideCircle = Circle(x: 5, y: 5, radius: 2)
        let outsideCircle = Circle(x: 100, y: 100, radius: 5)
        let node = Node(circles: [insideCircle, outsideCircle], frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        XCTAssertEqual(node.circles, [insideCircle])
    }
    
    func testSplitNode() {
        let left = Circle(x: 2, y: 5, radius: 1)
        let middle = Circle(x: 5, y: 5, radius: 5)
        let right = Circle(x: 8, y: 5, radius: 1)
        let nodes = Node.split(circles: [left, middle, right], frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let leftNode = nodes[0]
        XCTAssertEqual(leftNode.circles, [left, middle])

        let rightNode = nodes[0]
        XCTAssertEqual(rightNode.circles, [right, middle])
    }
    
}
