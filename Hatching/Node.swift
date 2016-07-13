//
//  Tree.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import CoreGraphics
import Foundation

class Node {
    
    let frame: CGRect
    var contents: Contents
    
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
    
    func remove(x x: Float, y: Float) -> Circle? {
        switch contents {
        case .Circles(let circles, let limit):
            for (idx, item) in circles.enumerate() {
                if item.containsPoint(x: x, y: y) {
                    var removed = circles
                    removed.removeAtIndex(idx)
                    contents = .Circles(removed, limit)
                    return item
                }
            }
            return nil
        case let .Deeper(nodes):
            var circle: Circle?
            for node in nodes {
                if let removed = node.remove(x: x, y: y) {
                    circle = removed
                }
            }
        
            return circle
        }
    }

    func add(circle circle: Circle) {
        switch contents {
        case let .Circles(circles, limit):
            let added = circles + [circle]
            if added.count >= limit {
                contents = .Deeper(Node.split(circles: added, frame: frame))
            } else {
                contents = .Circles(added, limit)
            }
        case let .Deeper(nodes):
            for node in nodes {
                if node.frame.intersects(circle) {
                    node.add(circle: circle)
                }
            }
        }
    }
}
