//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

public enum Event {
    case added(Circle)
    case removed(Circle)
}

final public class Hatchery {
    
    public let maxSize: Float
    public let viewport: Viewport
    internal let generator: RandomGenerator
    
    fileprivate var running = true
    
    fileprivate let q = DispatchQueue(label: "com.circlone.hatchery", attributes: [])
    
    fileprivate var storage: Storage
    fileprivate var produced = [Event]()
    
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
    
    public convenience init(viewport: Viewport, maxSize: Float) {
        self.init(viewport: viewport, maxSize: maxSize, storage: Storage(viewport: viewport), generator: RandomGenerator())
    }
    
    internal init(viewport: Viewport, maxSize: Float, storage: Storage, generator: RandomGenerator) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.storage = storage
        self.generator = generator
    }
        
    public func removeCircleAt(x: Float, y: Float) {
        q.async {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.produced.append(.removed(removedCircle))
            }
        }
    }
    
    public func generateCircles() {
        q.async {
            if !self.running {
                return
            }
            let circles = (0..<10000).map { _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
            let newEvents = self.storage.add(circles).map { Event.added($0) }
            self.produced.append(contentsOf: newEvents)
            self.generateCircles()
        }
    }
    
    public func consumeAll() -> [Event] {
        var events = [Event]()
        q.sync {
            events.append(contentsOf: self.produced)
            produced.removeAll()
        }
        return events
    }
}
