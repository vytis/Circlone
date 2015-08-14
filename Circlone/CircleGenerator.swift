//
//  CircleGenerator.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

protocol CircleGenerator {
    func generate(viewport: Viewport, maxSize: Float) -> Circle
}

class RandomGenerator: CircleGenerator {
    func generate(viewport: Viewport, maxSize: Float) -> Circle {
        let radius = Float(arc4random_uniform(uint(maxSize)) + 1)
        
        let x = Float(arc4random_uniform(uint(viewport.width - radius)) + uint(radius))
        let y = Float(arc4random_uniform(uint(viewport.height - radius)) + uint(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
}
