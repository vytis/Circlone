//
//  Circle.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

struct Circle {
    let x: Float
    let y: Float
    let radius: Float

    func collides(circle: Circle) -> Bool {
        let otherCircle = circle
        let delta_x = x - otherCircle.x;
        let delta_y = y - otherCircle.y;
        let distance_sq = delta_x * delta_x + delta_y * delta_y;
        let radiuses = radius + otherCircle.radius;
        return distance_sq < radiuses * radiuses
    }
    
    func fits(circles:[Circle]) -> Bool {
        for circle in circles {
            if self.collides(circle) {
                return false
            }
        }
        return true
    }
}


