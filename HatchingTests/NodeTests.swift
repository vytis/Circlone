//
//  TreeTests.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import XCTest
@testable import Hatching

extension Node {
    var circles: [Circle] {
        switch contents {
        case let .circles(circles):
            return circles
        case .deeper:
            return []
        }
    }
    
}

class NodeTests: XCTestCase {
    let insideCircle = Circle(x: 5, y: 5, radius: 2)
    let outsideCircle = Circle(x: 100, y: 100, radius: 5)
    let one = Circle(x: 2, y: 2, radius: 2)
    let two = Circle(x: 6, y: 6, radius: 2)
    let frame = CGRect(x: 0, y: 0, width: 10, height: 10)


    func testNodeAddsOnlyIntersectingCircles() {
        let node = Node(circles: [insideCircle, outsideCircle], frame: frame)
        XCTAssertEqual(node.circles, [insideCircle])
    }
    
    func testSplitNode() {
        let left = Circle(x: 2, y: 5, radius: 1)
        let middle = Circle(x: 5, y: 5, radius: 5)
        let right = Circle(x: 8, y: 5, radius: 1)
        let nodes = Node.split(circles: [left, middle, right], frame: frame)
        
        let leftNode = nodes[0]
        XCTAssertEqual(leftNode.circles, [left, middle])

        let rightNode = nodes[0]
        XCTAssertEqual(rightNode.circles, [right, middle])
    }
    
    func testCollideNodeWhenDoesntIntersectFrame() {
        let node = Node(circles: [insideCircle], frame: frame)
        XCTAssertFalse(node.collides(outsideCircle))
    }
    
    func testCollidesWhenContainingCirclesCollide() {
        let node = Node(circles: [one, two], frame: frame)
        let target = Circle(x: 3, y: 3, radius: 2)
        XCTAssertTrue(node.collides(target))
        let outside = Circle(x: 9, y: 9, radius: 1)
        XCTAssertFalse(node.collides(outside))
    }
    
    func testCollidesWhenContainingDeeperNode() {
        let top = Node(circles: [one], frame: frame.topSide)
        let bottom = Node(circles: [two], frame: frame.bottomSide)
        
        let node = Node(contents: .deeper([top, bottom]), frame: frame)
        
        let target = Circle(x: 3, y: 3, radius: 2)
        XCTAssertTrue(node.collides(target))
        let outside = Circle(x: 9, y: 9, radius: 1)
        XCTAssertFalse(node.collides(outside))
    }
    
    func testRemoveCircleFromTopNode() {
        var node = Node(circles: [one, two], frame: frame)
        let notExisting = node.remove(x: 0, y: 0)
        XCTAssertNil(notExisting)
        
        let removed = node.remove(x: 1, y: 1)
        XCTAssertEqual(removed, one)
        
        XCTAssertEqual(node.circles, [two])
    }
    
    func testRemoveCircleFromDeeperNode() {
        let top = Node(circles: [one], frame: frame.topSide)
        let bottom = Node(circles: [two], frame: frame.bottomSide)
        
        var node = Node(contents: .deeper([top, bottom]), frame: frame)
        
        let notExisting = node.remove(x: 0, y: 0)
        XCTAssertNil(notExisting)

        let removed = node.remove(x: 1, y: 1)
        XCTAssertEqual(removed, one)
    }
}

