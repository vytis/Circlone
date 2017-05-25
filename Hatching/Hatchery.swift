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
    
    fileprivate var running = true
    
    fileprivate let q = DispatchQueue(label: "com.circlone.hatchery", attributes: [])
    
    fileprivate var storage: Storage
    public fileprivate(set) weak var delegate: HatcheryDelegate?
    
    public var allCircles: [Circle] {
        return storage.all
    }

    public func stop() {
        q.sync {
            self.running = false
        }
    }
    
    public func start() {
        q.sync {
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
        
    public func removeCircleAt(x: Float, y: Float) {
        q.async {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.delegate?.hatcheryRemoved(circles: [removedCircle])
            }
        }
    }
    
    public func generateCircles() {
        q.async {
            if !self.running {
                return
            }
            let circles = (0..<10000).map { _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
            let newCircles = self.storage.add(circles)
            self.delegate?.hatcheryAdded(circles: newCircles)
            self.generateCircles()
        }
    }
}
