//
//  Circle+Collision.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation

public extension Circle {
    func containsPoint(x: Float, y: Float) -> Bool {
        return collides(Circle(x: x, y: y, radius: 0))
    }
    
    func collides(_ other: Circle) -> Bool {
        let delta_x = x - other.x;
        let delta_y = y - other.y;
        let distance_sq = delta_x * delta_x + delta_y * delta_y;
        let radiuses = radius + other.radius;
        return distance_sq < radiuses * radiuses
    }
    
    func collides(_ others: [Circle]) -> Bool {
        for other in others {
            if collides(other) {
                return true
            }
        }
        return false
    }
}
