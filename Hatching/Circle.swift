//
//  Circle.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

public func <(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius < rhs.radius
}

public func ==(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius == rhs.radius
}

public struct Circle: Comparable {
    public let x: Float
    public let y: Float
    public let radius: Float
    
    public init(x: Float, y: Float, radius: Float) {
        self.x = x
        self.y = y
        self.radius = radius
    }    
}

public extension Circle {
    public func containsPoint(x x: Float, y: Float) -> Bool {
        return collides(Circle(x: x, y: y, radius: 0))
    }
    
    public func collides(other: Circle) -> Bool {
        let delta_x = x - other.x;
        let delta_y = y - other.y;
        let distance_sq = delta_x * delta_x + delta_y * delta_y;
        let radiuses = radius + other.radius;
        return distance_sq < radiuses * radiuses
    }
    
    public func collides(others: [Circle]) -> Bool {
        for other in others {
            if collides(other) {
                return true
            }
        }
        return false
    }
}
