//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

public typealias Circles = ([Circle]) -> Void

final public class Hatchery {
    
    let maxSize: Float
    let viewport: Viewport
    let generator = RandomGenerator()
    
    private var running = true
    
    private let q = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)

    
    private let storage: Storage
    private let addedCircles: Circles?
    private let removedCircles: Circles?

    public func stop() {
        dispatch_sync(q) {
            self.running = false
        }
    }
    
    public func saveSVG(atPath path: String) {
        storage.saveSVG(atPath: path)
    }
    
    public func start() {
        dispatch_sync(q) {
            self.running = true
        }
        generateCircles()
    }
    
    public init(viewport: Viewport, maxSize: Float, addedCircles: Circles? = nil, removedCircles: Circles? = nil) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.addedCircles = addedCircles
        self.removedCircles = removedCircles
        storage = Storage(viewport: viewport)
        generateCircles()
    }
        
    public func removeCircleAt(x x: Float, y: Float) {
        dispatch_async(q) {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.removedCircles?([removedCircle])
            }
        }
    }
    
    public func generateCircles() {
        dispatch_async(q) {
            if !self.running {
                return
            }
            var circles = [Circle]()
            for _ in (0..<10000) {
                circles.append(self.generator.generate(self.viewport, maxSize: self.maxSize))
            }
            let newCircles = self.storage.add(circles)
            self.addedCircles?(newCircles)
            self.generateCircles()
        }
    }
}
