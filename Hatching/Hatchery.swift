//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation


final public class Hatchery {
    
    public let maxSize: Float
    public let viewport: Viewport
    internal let generator = RandomGenerator(seed: 123)
    
    private var running = true
    
    private let q = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)
    
    private var storage: Storage
    public private(set) weak var delegate: HatcheryDelegate?
    
    public var allCircles: [Circle] {
        return storage.all
    }

    public func stop() {
        dispatch_sync(q) {
            self.running = false
        }
    }
    
    public func start() {
        dispatch_sync(q) {
            self.running = true
        }
        generateCircles()
    }
    
    public init(viewport: Viewport, maxSize: Float, delegate: HatcheryDelegate? = nil) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.delegate = delegate
        storage = Storage(viewport: viewport)
        generateCircles()
    }
        
    public func removeCircleAt(x x: Float, y: Float) {
        dispatch_async(q) {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.delegate?.hatcheryRemoved(circles: [removedCircle])
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
            self.delegate?.hatcheryAdded(circles: newCircles)
            self.generateCircles()
        }
    }
}
