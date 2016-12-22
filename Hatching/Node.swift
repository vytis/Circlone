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
        case circles(Int)
        case deeper([Node])
    }
    
    internal init(circles: [Circle], frame: CGRect, splitLimit: Int = 500) {
        self.circles = circles.filter(frame.intersects)
        self.contents = .circles(splitLimit)
        self.frame = frame
    }
    
    internal static func split(circles: [Circle], frame: CGRect) -> [Node] {
        
        let one = Node(circles: circles, frame: frame.leftSide.topSide)
        let two = Node(circles: circles, frame: frame.rightSide.topSide)
        let three = Node(circles: circles, frame: frame.bottomSide.rightSide)
        let four = Node(circles: circles, frame: frame.bottomSide.leftSide)

        return [one, two, three, four]
    }
    
    internal func collides(_ circle: Circle) -> Bool {
        guard frame.intersects(circle) else {
            return false
        }
        switch contents {
        case .circles:
            return circle.collides(circles)
        case let .deeper(nodes):
            for node in nodes {
                if node.collides(circle) {
                    return true
                }
            }
            return false
        }
    }
    
    internal mutating func remove(x: Float, y: Float) -> Circle? {
        switch contents {
        case .circles:
            for (idx, item) in circles.enumerated() {
                if item.containsPoint(x: x, y: y) {
                    circles.remove(at: idx)
                    return item
                }
            }
            return nil
        case var .deeper(nodes):
            var circle: Circle?
            for idx in 0..<nodes.count {
                if let removed = nodes[idx].remove(x: x, y: y) {
                    circle = removed
                }
            }
            contents = .deeper(nodes)
            return circle
        }
    }

    internal mutating func add(circle: Circle) {
        switch contents {
        case .circles(let limit):
            circles.append(circle)
            if circles.count >= limit {
                contents = .deeper(Node.split(circles: circles, frame: frame))
                circles = []
            } else {
                contents = .circles(limit)
            }
        case var .deeper(nodes):
            for (idx, node) in nodes.enumerated() {
                if node.frame.intersects(circle) {
                    nodes[idx].add(circle: circle)
                }
            }
            contents = .deeper(nodes)
        }
    }
}
