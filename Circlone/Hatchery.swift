//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

typealias OnCircles = ([Circle] -> Void)

class Hatchery {
    
    let maxSize: Float
    let viewport: Viewport
    var running = false {
        didSet {
            if (running) {
                hatch()
            }
        }
    }
    
    private let hatchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

    private var circles: [Circle] = []
    
    init(viewport:Viewport, maxSize:Float) {
        self.viewport = viewport
        self.maxSize = maxSize;
    }
    
    func fetchAllCircles(onCircles: OnCircles) {
        dispatch_async(dispatch_get_main_queue()) {
            let circles = self.circles
            onCircles(circles)
        }
    }
    
    private func randomCircle(viewport: Viewport, maxSize: Float) -> Circle {
        let radius = Float(arc4random_uniform(uint(maxSize)) + 1)

        let x = Float(arc4random_uniform(uint(viewport.width - radius)) + uint(radius))
        let y = Float(arc4random_uniform(uint(viewport.height - radius)) + uint(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
    
    private func hatch() {
        dispatch_async(hatchQueue) {
            while(self.running) {
                let circle = self.randomCircle(self.viewport, maxSize: self.maxSize)
                var circles: [Circle] = []
                dispatch_sync(dispatch_get_main_queue()) {
                    circles = self.circles
                }
                if (circle.fits(circles)) {
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.circles = circles + [circle]
                    }
                }
            }
        }
    }
    
    
}
