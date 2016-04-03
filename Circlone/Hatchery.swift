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
    
    private var running = true
    
    private let q = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)

    private let storage: Storage
    private let addedCirclesSubscriber: Subscriber
    private let removedCirclesSubscriber: Subscriber

    func stop() {
        dispatch_sync(q) {
            self.running = false
        }
    }
    
    init(viewport: Viewport, maxSize: Float, newCircles: Subscriber, removedCircles: Subscriber) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.storage = Storage(pivotPoint: Circle(x: 0, y: 0, radius: 2))
        addedCirclesSubscriber = newCircles
        removedCirclesSubscriber = removedCircles
        generateCircles()
    }
    
    func removeCircleAt(x x: Float, y: Float) {
        dispatch_async(q) {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.removedCirclesSubscriber.addNew([removedCircle])
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
            self.addedCirclesSubscriber.addNew(newCircles)
            self.generateCircles()
        }
    }
}
