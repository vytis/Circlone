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
    let generator: CircleGenerator
    
    var running = false {
        didSet {
            if (running) {
                hatch()
            }
        }
    }
    
    private let hatchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

    private var storage = Storage<Circle>()

    init(viewport:Viewport, maxSize:Float, generator: CircleGenerator = RandomGenerator()) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.generator = generator
    }
    
    func popNewCircles() -> [Circle] {
        return storage.popAllNew()
    }
    
    private func randomCircle() -> Circle {
        return generator.generate(viewport, maxSize: maxSize)
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
