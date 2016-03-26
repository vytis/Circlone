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
    let generator = RandomGenerator()
    
    var running = false {
        didSet {
            if (running) {
                hatch()
            }
        }
    }
    
    private let hatchQueue = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)

    private var storage: Storage
    
    func reset() {
        running = false
        let pivot = storage.pivotPoint
        dispatch_async(hatchQueue) { () -> Void in
            self.storage = Storage(pivotPoint: pivot)
        }
    }
    
    init(viewport: Viewport, maxSize: Float, pivot: Circle = Circle(x: 0, y: 0, radius: 2)) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.storage = Storage(pivotPoint: pivot)
        self.popNewCircles = {_ in}
    }
    
    var popNewCircles: [Circle] -> Void
    
    func removeCircleAt(x x: Float, y: Float, circle: Circle -> Void) {
        storage.popItemAt(x: x, y: y) { newCircle in
            dispatch_sync(dispatch_get_main_queue()) {
                circle(newCircle)
            }
        }
    }
        
    private func hatch() {
        dispatch_async(hatchQueue) {
            var circles = [Circle]()
            for _ in (0..<1000) {
                circles.append(self.generator.generate(self.viewport, maxSize: self.maxSize))
            }
            self.storage.add(circles) { newCircles in
                if self.running {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.popNewCircles(newCircles)
                    }
                    self.hatch()
                }
            }
        }
    }
}
