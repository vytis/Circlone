//
//  Viewport.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-07-13.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

struct Viewport {
    let height: Float
    let width: Float
    
    init (height: Float, width: Float) {
        self.height = height
        self.width = width
    }
    
    func fits(circle: Circle) -> Bool {
        return (circle.x - circle.radius >= 0) && (circle.y - circle.radius >= 0) && (circle.x + circle.radius <= width) && (circle.y + circle.radius <= height)
    }
}