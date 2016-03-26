//
//  CircleGenerator.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

protocol CircleGenerator {
    func generate(viewport: Viewport, maxSize: Float) -> Circle
}

class RandomGenerator {
    func generate(viewport: Viewport, maxSize: Float) -> Circle {
        
        let realMax = min(maxSize, viewport.width / 2.0 - 1)
        
        let radius = Float(arc4random_uniform(uint(realMax)) + 1)
        let limit = uint(viewport.width - 2 * radius)
        let x = Float(arc4random_uniform(limit) + uint(radius))
        let y = Float(arc4random_uniform(uint(viewport.height - 2 * radius)) + uint(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
}

class SeededRandomGenerator {
    init(seed: Int = 100) {
        srand(UInt32(seed))
    }
    
    func generate(viewport: Viewport, maxSize: Float) -> Circle {
        
        let radius = Float(rand() % Int32(maxSize) + 1)
        
        let x = Float(rand() % Int32(viewport.width - radius) + Int32(radius))
        let y = Float(rand() % Int32(viewport.height - radius) + Int32(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
}
