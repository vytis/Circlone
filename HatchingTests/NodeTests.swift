import XCTest
@testable import Hatching

class NodeTests: XCTestCase {

    func testNodeAddsOnlyIntersectingCircles() {
        let node = Node(circles: [insideCircle, outsideCircle], frame: frame)
        XCTAssertEqual(node.contents, .circles([insideCircle]))
    }
    
    func testSplitNodes() {
        let left = Circle(x: 2, y: 5, radius: 1)
        let middle = Circle(x: 5, y: 5, radius: 5)
        let right = Circle(x: 8, y: 5, radius: 1)
        let nodes = Node.split(circles: [left, middle, right], frame: frame)
        let nodeFrames = nodes.map { $0.frame }

        // Source frame split without gaps:
        // * None of the frames intersect together
        // * Total area is equal to initial frame area
        var area: CGFloat = 0
        for (idx, item) in nodeFrames.enumerated() {
            for (otherIdx, otherItem) in nodeFrames.enumerated() {
                if idx == otherIdx { continue }
                XCTAssertFalse(item.intersects(otherItem), "Frames should not intersect: \(item) and \(otherItem)")
            }

            area += item.height * item.width
        }
        XCTAssertEqual(area, frame.width * frame.height)
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
        
        XCTAssertEqual(node.contents, .circles([two]))
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

    func testAddingCircleToTopNode() {
        var node = Node(contents: .circles([one]), frame: frame)
        node.add(circle: two)

        XCTAssertEqual(node.contents, .circles([one, two]))
    }

    func testAddingAndSplitting() {
        var node = Node(contents: .circles([one]), frame: frame, splitLimit: 1)
        node.add(circle: two)

        let afterSplit = Node.split(circles: [one, two], frame: frame)
        XCTAssertEqual(node.contents, .deeper(afterSplit))
    }

    func testAddingAndAppendingToCorrectNode() {
        var leftNode = Node(contents: .circles([one]), frame: frame.leftSide)
        let rightNode = Node(contents: .circles([two]), frame: frame.rightSide)
        var node = Node(contents: .deeper([leftNode, rightNode]), frame: frame)

        let inLeft = Circle(x: 3, y: 3, radius: 1)
        node.add(circle: inLeft)

        leftNode.add(circle: inLeft)

        XCTAssertEqual(node.contents, .deeper([leftNode, rightNode]))
    }
}

