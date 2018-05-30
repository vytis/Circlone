//
//  RandomGenerator.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

final internal class RandomGenerator {
    
    fileprivate var number: UInt64

    internal init(seed: UInt64 = UInt64(arc4random())) {
        number = seed
    }

    internal func generate(_ viewport: Viewport, minSize: Float = 1.0, maxSize: Float) -> Circle {
        
        let realMax = min(maxSize, viewport.width / 2.0 - 1)
        
        let radius = rand_uniform(realMax - minSize) + minSize
        let limit = viewport.width - 2 * radius
        let x = rand_uniform(limit) + radius
        let y = rand_uniform(viewport.height - 2 * radius) + radius
        
        return Circle(x:x, y:y, radius:radius)
    }
    
    fileprivate func rand_uniform(_ limit: Float) -> Float {
        
        number ^= number >> 12;
        number ^= number << 25;
        number ^= number >> 27;
        
        let (multiplied, _) = number.multipliedReportingOverflow(by: 2685821657736338717)
        let range = Double(multiplied) / Double(UInt64.max)
        
        return Float(Double(limit) * range)
    }
}
