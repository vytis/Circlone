//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

public typealias Circles = ([Circle]) -> Void

public class Hatchery {
    
    let maxSize: Float
    let viewport: Viewport
    let generator = RandomGenerator()
    
    private var running = true
    
    private let q = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)

    
    private let storage: Storage
    private let addedCirclesSubscriber: Circles
    private let removedCirclesSubscriber: Circles

    public func stop() {
        dispatch_sync(q) {
            self.running = false
            self.storage.saveSVG(atPath: "all.svg")
        }
    }
    
    public func start() {
        dispatch_sync(q) {
            self.running = true
        }
        generateCircles()
    }
    
    public init(viewport: Viewport, maxSize: Float, newCircles: Circles, removedCircles: Circles) {
        self.viewport = viewport
        self.maxSize = maxSize
        storage = Storage(viewport: viewport)
        addedCirclesSubscriber = newCircles
        removedCirclesSubscriber = removedCircles
        generateCircles()
    }
        
    public func removeCircleAt(x x: Float, y: Float) {
        dispatch_async(q) {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.removedCirclesSubscriber([removedCircle])
            }
        }
    }
    
    public func generateCircles() {
        dispatch_async(q) {
            if !self.running {
                return
            }
            var circles = [Circle]()
            for _ in (0..<1000) {
                circles.append(self.generator.generate(self.viewport, maxSize: self.maxSize))
            }
            let newCircles = self.storage.add(circles)
            self.addedCirclesSubscriber(newCircles)
            self.generateCircles()
        }
    }
}
