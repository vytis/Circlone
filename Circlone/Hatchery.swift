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
    var running = false {
        didSet {
            if (running) {
                hatch()
            }
        }
    }
    
    private let hatchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    private let circlesQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

    private var storage = Storage<Circle>()

    init(viewport:Viewport, maxSize:Float) {
        self.viewport = viewport
        self.maxSize = maxSize;
    }
    
    func popNewCircles() -> [Circle] {
        return storage.popAllNew()
    }
    
    private func randomCircle(viewport: Viewport, maxSize: Float) -> Circle {
        let radius = Float(arc4random_uniform(uint(maxSize)) + 1)

        let x = Float(arc4random_uniform(uint(viewport.width - radius)) + uint(radius))
        let y = Float(arc4random_uniform(uint(viewport.height - radius)) + uint(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
    
    private func randomCircle() -> Circle {
        return randomCircle(viewport, maxSize: maxSize)
    }
    
    private func hatch() {
        dispatch_async(hatchQueue) {
            while(self.running) {
                let circle = self.randomCircle()
                let circles = self.storage.fetchAll()
                
                if (circle.fits(circles)) {
                    self.storage.pushNew(circle)
                }
            }
        }
    }
}
