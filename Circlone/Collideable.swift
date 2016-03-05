//
//  Collideable.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-03-05.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation

protocol Collideable {
    func collides(other: Self) -> Bool
    func containsPoint(x x: Float, y: Float) -> Bool
}

extension Collideable {
    func collides(others: [Self]) -> Bool {
        for other in others {
            if collides(other) {
                return true
            }
        }
        return false
    }
}
