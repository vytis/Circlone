//
//  Tree.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import CoreGraphics
import Foundation

internal struct Node: Equatable {
    
    internal let frame: CGRect
    internal var contents: Contents
    internal let splitLimit: Int
    
    internal enum Contents: Equatable {
        case circles([Circle])
        case deeper([Node])
    }
    
    internal static func split(circles: [Circle], frame: CGRect) -> [Node] {
        
        let one = Node(circles: circles, frame: frame.leftSide.topSide)
        let two = Node(circles: circles, frame: frame.rightSide.topSide)
        let three = Node(circles: circles, frame: frame.rightSide.bottomSide)
        let four = Node(circles: circles, frame: frame.leftSide.bottomSide)

        return [one, two, three, four]
    }
    
    internal func collides(_ circle: Circle) -> Bool {
        guard frame.intersects(circle) else {
            return false
        }
        switch contents {
        case let .circles(items):
            return circle.collides(items)
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
        case let .circles(circles):
            var updated = circles
            for (idx, item) in updated.enumerated() {
                if item.containsPoint(x: x, y: y) {
                    updated.remove(at: idx)
                    contents = .circles(updated)
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
        case let .circles(circles):
            var updated = circles
            updated.append(circle)
            if updated.count >= splitLimit {
                contents = .deeper(Node.split(circles: updated, frame: frame))
            } else {
                contents = .circles(updated)
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

internal extension Node {
    init(contents: Contents, frame: CGRect, splitLimit: Int = 500) {
        self.splitLimit = splitLimit
        self.frame = frame
        self.contents = contents
    }

    init(circles: [Circle], frame: CGRect, splitLimit: Int = 500) {
        self.init(contents: .circles(circles.filter(frame.intersects)), frame: frame, splitLimit: splitLimit)
    }
}
