//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

public enum Event: Equatable {
    case added(Circle)
    case removed(Circle)
}

final public class Hatchery {

    typealias Generate = () -> Circle
    
    public let maxSize: Float
    public let viewport: Viewport
    internal let generate: Generate
    
    public fileprivate(set) var running = false
    
    fileprivate let q = DispatchQueue(label: "com.circlone.hatchery", qos: .userInitiated)
    
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
        let generator = RandomGenerator(viewport: viewport, maxSize: maxSize)
        self.init(viewport: viewport, maxSize: maxSize, generate: generator.generate)
    }

    internal init(viewport: Viewport, maxSize: Float, generate: @escaping Generate) {
        self.viewport = viewport
        self.maxSize = maxSize
        self.generate = generate
        storage = Storage(viewport: viewport)
    }
        
    public func removeCircleAt(x: Float, y: Float) {
        q.async {
            if let removedCircle = self.storage.popItemAt(x: x, y: y)   {
                self.produced.append(.removed(removedCircle))
            }
        }
    }
    
    internal func generateCircles() {
        q.async {
            if !self.running {
                return
            }
            let circles = (0..<10000).map { _ in self.generate() }
            let newEvents = self.storage.add(circles).map { Event.added($0) }
            self.produced.append(contentsOf: newEvents)
            self.generateCircles()
        }
    }
    
    public func consumeEvents() -> [Event] {
        var events = [Event]()
        q.sync {
            events.append(contentsOf: self.produced)
            produced.removeAll()
        }
        return events
    }
}
