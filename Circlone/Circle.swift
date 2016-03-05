//
//  Circle.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

func <(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius < rhs.radius
}

func ==(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius == rhs.radius
}

struct Circle: Comparable {
    let x: Float
    let y: Float
    let radius: Float
    
    static let maxRadius: Float = 100
    
    var normalizedRadius: Float {
        return radius / Circle.maxRadius
    }
}

extension Circle: Collideable {
    func containsPoint(x x: Float, y: Float) -> Bool {
        return collides(Circle(x: x, y: y, radius: 0))
    }
    
    func collides(other: Circle) -> Bool {
        let delta_x = x - other.x;
        let delta_y = y - other.y;
        let distance_sq = delta_x * delta_x + delta_y * delta_y;
        let radiuses = radius + other.radius;
        return distance_sq < radiuses * radiuses
    }
}
