//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import UIKit

class Hatchery {
    
    let maxSize: Float
    let viewport: Viewport
    let generator = RandomGenerator()
    
    private var running = true
    
    private let q = dispatch_queue_create("com.circlone.hatchery", DISPATCH_QUEUE_SERIAL)

    private let storage: Storage
    private let addedCirclesSubscriber: Subscriber
    private let removedCirclesSubscriber: Subscriber
    
    deinit {
        addedCirclesSubscriber.stop()
        removedCirclesSubscriber.stop()
    }

    func stop() {
        dispatch_sync(q) {
            self.running = false
            self.storage.saveSVG(atPath: "all.svg")
        }
    }
    
    func start() {
        dispatch_sync(q) {
            self.running = true
        }
        generateCircles()
    }
    
    init(viewport: Viewport, maxSize: Float, newCircles: Subscriber, removedCircles: Subscriber, statePath: String?) {
        self.viewport = viewport
        self.maxSize = maxSize
        if let path = statePath,
            let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last,
            let data = NSData(contentsOfFile: (documentsDir as NSString).stringByAppendingPathComponent(path)),
            let storage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Storage {
            self.storage = storage
        } else {
            self.storage = Storage(viewport: viewport)
        }
        addedCirclesSubscriber = newCircles
        removedCirclesSubscriber = removedCircles
        generateCircles()
    }
    
    func saveState(toFile path: String) {
        if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last {
            let fullPath = (documentsDir as NSString).stringByAppendingPathComponent(path)
            NSKeyedArchiver.archiveRootObject(storage, toFile: fullPath)
        }
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
