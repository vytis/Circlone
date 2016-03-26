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
    
    var running = false
    
    private let q = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)

    private var storage: Storage
    
    func reset() {
        dispatch_sync(q) {
            self.running = false
            self.popNewCircles = nil
            let pivot = self.storage.pivotPoint
            self.storage = Storage(pivotPoint: pivot)
        }
    }
    
    init(viewport: Viewport, maxSize: Float, pivot: Circle = Circle(x: 0, y: 0, radius: 2)) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.storage = Storage(pivotPoint: pivot)
    }
    
    var popNewCircles: ([Circle] -> Void)? = nil
    
    func removeCircleAt(x x: Float, y: Float, circle: Circle -> Void) {
        dispatch_async(q) {
            if let newCircle = self.storage.popItemAt(x: x, y: y)   {
                dispatch_async(dispatch_get_main_queue()) {
                    circle(newCircle)
                }
            }
        }
    }
    
    func generateCircles() {
        dispatch_async(q) {
            if !self.running {
                return
            }
            var circles = [Circle]()
            for _ in (0..<1000) {
                circles.append(self.generator.generate(self.viewport, maxSize: self.maxSize))
            }
            let newCircles = self.storage.add(circles)
            dispatch_async(dispatch_get_main_queue()) {
                self.popNewCircles?(newCircles)
            }
            self.generateCircles()
        }
    }
}
