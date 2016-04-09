//: Playground - noun: a place where people can play

import UIKit

let maxX = 500
let maxY = 500

struct Circle {
    var x: Float
    var y: Float
    var radius: Float
    
    init(x: Float, y: Float, radius: Float) {
        self.x = x
        self.y = y
        self.radius = radius
    }
    
    func collidesWith(other: Circle) -> Bool {
        let delta_x = x - other.x;
        let delta_y = y - other.y;
        let distance_sq = delta_x * delta_x + delta_y * delta_y;
        let radiuses = radius + other.radius;
        return distance_sq < radiuses * radiuses
    }
    
    func collides(others: [Circle]) -> Bool {
        for other in others {
            if collidesWith(other) {
                return true
            }
        }
        return false
    }
}

extension CGRect {
    func contains(circle: Circle) -> Bool {
        return true
    }
    
    var leftSide: CGRect {
        return CGRect(origin: origin, size: CGSize(width: width / 2.0, height: height))
    }
    
    var rightSide: CGRect {
        return CGRect(x: origin.x + width / 2.0, y: origin.y, width: width / 2.0, height: height)
    }
}

class Node {
    
    static let limit = 2
    let frame: CGRect
    var contents: Contents

    enum Contents {
        case Circles([Circle])
        case Deeper(Node, Node)
    }
    
    init(circles: [Circle], frame: CGRect) {
        let circlesInFrame = circles.filter(frame.contains)
        self.contents = .Circles(circlesInFrame)
        self.frame = frame
    }
    
    func add(circle circle: Circle) -> Circle? {
        if !frame.contains(circle) {
            return nil
        }
        
        switch contents {
        case var .Circles(circles):
            if circle.collides(circles) {
                return nil
            } else {
                circles.append(circle)
                if circles.count >= Node.limit {
                    let left = Node(circles: circles, frame: frame.leftSide)
                    let right = Node(circles: circles, frame: frame.rightSide)
                    contents = .Deeper(left, right)
                }
                return circle
            }
        case let .Deeper(left, right):
            let addedLeft = left.add(circle: circle)
            let addedRight = right.add(circle: circle)
            
            if let addedLeft = addedLeft {
                return addedLeft
            }
         
            if let addedRight = addedRight {
                return addedRight
            }
            return nil
        }
    }
}

UInt64(2685821657736338717)
