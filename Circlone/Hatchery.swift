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
    
    private let hatchQueue = dispatch_queue_create("com.circles.hatchery", DISPATCH_QUEUE_SERIAL)

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
                let circles = self.storage.fetchAll()
                
                if (circle.fits(circles)) {
                    self.storage.pushNew(circle)
                }
            }
        }
    }

    private func asyncHatch() {
        dispatch_async(hatchQueue) {
            let q = dispatch_queue_create("com.circlone.hatch.collisions", DISPATCH_QUEUE_CONCURRENT)

            while(self.running) {
                
                let count = 1024
                let newCircles = self.randomCircles(count)
                
                let existingCircles = self.storage.fetchAll()
                
                let paralellCount = 16
                let perIteration = count / paralellCount
                dispatch_apply(paralellCount, q) {
                    
                    for idx in 0..<perIteration {
                        let circle = newCircles[$0 * paralellCount + idx]
                        
                        if (circle.fits(existingCircles)) {
                            self.storage.pushNew(circle)
                        }
                    }
                }
            }
        }
    }
}
