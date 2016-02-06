//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
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
    
    private let hatchQueue = dispatch_queue_create("com.circles.hatchery", DISPATCH_QUEUE_SERIAL)

    private var storage: Storage<Circle>
    
    func reset() {
        self.running = false
        self.storage = Storage<Circle>(pivotPoint: self.storage.pivotPoint)
    }
    
    init(viewport: Viewport, maxSize: Float, generator: CircleGenerator = RandomGenerator(), pivot: Circle = Circle(x: 0, y: 0, radius: 2)) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.generator = generator
        self.storage = Storage<Circle>(pivotPoint: pivot)
    }
    
    func popNewCircles() -> [Circle] {
        return storage.popAllNew()
    }
    
    func removeCircleAt(x x: Float, y: Float) -> Circle? {
        return storage.itemAt(x: x, y: y)
    }
    
    private func randomCircle() -> Circle {
        return generator.generate(viewport, maxSize: maxSize)
    }
    
    private func randomCircles(count: Int) -> [Circle] {
        var circles: [Circle] = []
        
        while circles.count < count {
            let circle = randomCircle()
            if (circle.fits(circles)) {
                circles += [circle]
            }
        }

        return circles
    }
    
    private func hatch() {
        dispatch_async(hatchQueue) {
            while(self.running) {
                let circle = self.randomCircle()
                
                if (circle.fits(self.storage) && self.running) {
                    self.storage.pushNew(circle)
                }
            }
        }
    }
}
