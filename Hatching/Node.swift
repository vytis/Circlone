//
//  Tree.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import CoreGraphics
import Foundation

struct Node {
    
    let frame: CGRect
    private var contents: Contents
    
    enum Contents {
        case Circles([Circle], Int)
        case Deeper([Node])
    }
    
    init(circles: [Circle], frame: CGRect, splitLimit: Int = 500) {
        let circlesInFrame = circles.filter(frame.intersects)
        self.contents = .Circles(circlesInFrame, splitLimit)
        self.frame = frame
    }
    
    static func split(circles circles: [Circle], frame: CGRect) -> [Node] {
        
        let one = Node(circles: circles, frame: frame.leftSide.topSide)
        let two = Node(circles: circles, frame: frame.rightSide.topSide)
        let three = Node(circles: circles, frame: frame.bottomSide.rightSide)
        let four = Node(circles: circles, frame: frame.bottomSide.leftSide)

        return [one, two, three, four]
    }
    
    func collides(circle circle: Circle) -> Bool {
        guard frame.intersects(circle) else {
            return false
        }
        switch contents {
        case .Circles(let circles, _):
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
    
    mutating func remove(x x: Float, y: Float) -> Circle? {
        switch contents {
        case .Circles(var circles, let limit):
            for (idx, item) in circles.enumerate() {
                if item.containsPoint(x: x, y: y) {
                    circles.removeAtIndex(idx)
                    contents = .Circles(circles, limit)
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

    mutating func add(circle circle: Circle) {
        switch contents {
        case let .Circles(circles, limit):
            let added = circles + [circle]
            if added.count >= limit {
                contents = .Deeper(Node.split(circles: added, frame: frame))
            } else {
                contents = .Circles(added, limit)
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
