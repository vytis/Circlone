//
//  Tree.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import CoreGraphics
import Foundation

internal struct Node {
    
    internal let frame: CGRect
    internal var contents: Contents
    internal var circles: [Circle]
    
    internal enum Contents {
        case Circles(Int)
        case Deeper([Node])
    }
    
    internal init(circles: [Circle], frame: CGRect, splitLimit: Int = 500) {
        self.circles = circles.filter(frame.intersects)
        self.contents = .Circles(splitLimit)
        self.frame = frame
    }
    
    internal static func split(circles circles: [Circle], frame: CGRect) -> [Node] {
        
        let one = Node(circles: circles, frame: frame.leftSide.topSide)
        let two = Node(circles: circles, frame: frame.rightSide.topSide)
        let three = Node(circles: circles, frame: frame.bottomSide.rightSide)
        let four = Node(circles: circles, frame: frame.bottomSide.leftSide)

        return [one, two, three, four]
    }
    
    internal func collides(circle circle: Circle) -> Bool {
        guard frame.intersects(circle) else {
            return false
        }
        switch contents {
        case .Circles:
            return circle.collides(circles)
        case let .Deeper(nodes):
            for node in nodes {
                if node.collides(circle: circle) {
                    return true
                }
            }
            return false
        }
    }
    
    internal mutating func remove(x x: Float, y: Float) -> Circle? {
        switch contents {
        case .Circles:
            for (idx, item) in circles.enumerate() {
                if item.containsPoint(x: x, y: y) {
                    circles.removeAtIndex(idx)
                    return item
                }
            }
            return nil
        case var .Deeper(nodes):
            var circle: Circle?
            for idx in 0...nodes.count {
                if let removed = nodes[idx].remove(x: x, y: y) {
                    circle = removed
                }
            }
            contents = .Deeper(nodes)
            return circle
        }
    }

    internal mutating func add(circle circle: Circle) {
        switch contents {
        case .Circles(let limit):
            circles.append(circle)
            if circles.count >= limit {
                contents = .Deeper(Node.split(circles: circles, frame: frame))
                circles = []
            } else {
                contents = .Circles(limit)
            }
        case var .Deeper(nodes):
            for (idx, node) in nodes.enumerate() {
                if node.frame.intersects(circle) {
                    nodes[idx].add(circle: circle)
                }
            }
            contents = .Deeper(nodes)
        }
    }
}
