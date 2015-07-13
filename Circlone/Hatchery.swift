//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

class Hatchery {
    
    let maxSize: Float
    let viewport: Viewport
    let hatchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    var circles: [Circle] = []
    
    init(viewport:Viewport, maxSize:Float) {
        self.viewport = viewport
        self.maxSize = maxSize;
    }
    
    func randomCircle(viewport: Viewport, maxSize: Float) -> Circle {
        let radius = Float(arc4random_uniform(uint(maxSize)) + 1)

        let x = Float(arc4random_uniform(uint(viewport.width - radius)) + uint(radius))
        let y = Float(arc4random_uniform(uint(viewport.height - radius)) + uint(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
    
    func hatch(onHatch: (Circle -> Void)) {
        dispatch_async(hatchQueue) {
            while(true) {
                let circle = self.randomCircle(self.viewport, maxSize: self.maxSize)
                if (circle.isValid(self.viewport, circles: self.circles)) {
                    self.circles += [circle]
                    dispatch_async(dispatch_get_main_queue()) {
                        onHatch(circle)
                    }
                    break
                }
            }
        }
    }
}
